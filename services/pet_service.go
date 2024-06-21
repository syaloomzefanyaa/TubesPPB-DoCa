package services

import (
	"API_DoCa/models"
	"crypto/sha256"
	"database/sql"
	"errors"
	"fmt"
	"io"
	"log"
	"mime/multipart"
	"os"
	"path/filepath"
	"strconv"
	"github.com/gofiber/fiber/v2"
)

// PetService adalah layanan untuk operasi terkait produk
type PetService struct {
	DB *sql.DB
	Hostname string
    Port     int
}

// saveImage menyimpan gambar dan mengembalikan URL gambar
func (petService *PetService) saveImage(file *multipart.FileHeader) (string, error) {
	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()

	// Buat hash dari file
	hash := sha256.New()
	if _, err := io.Copy(hash, src); err != nil {
		return "", err
	}
	hashSum := fmt.Sprintf("%x", hash.Sum(nil))

	// Set path untuk menyimpan gambar
	dstPath := filepath.Join("uploads", hashSum+filepath.Ext(file.Filename))

	// Buat direktori jika belum ada
	if err := os.MkdirAll(filepath.Dir(dstPath), 0755); err != nil {
		return "", err
	}

	// Salin file ke lokasi tujuan
	dst, err := os.Create(dstPath)
	if err != nil {
		return "", err
	}
	defer dst.Close()

	if _, err := src.Seek(0, io.SeekStart); err != nil {
		return "", err
	}
	if _, err := io.Copy(dst, src); err != nil {
		return "", err
	}

	return "/" + dstPath, nil
}

func (petService *PetService) CreatePetData(c *fiber.Ctx) error {
	// Parse data form
	form, err := c.MultipartForm()
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Gagal memproses data form",
		})
	}

	files := form.File["image_pet"]
	if len(files) == 0 {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Gambar diperlukan",
		})
	}

	// Asumsikan hanya ada satu file yang diunggah
	file := files[0]

	// Simpan gambar menggunakan fungsi saveImage
	imagePath, err := petService.saveImage(file)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal menyimpan gambar",
		})
	}

	// Konversi nilai form ke tipe yang sesuai
	userID, err := strconv.Atoi(c.FormValue("id_user"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID pengguna tidak valid",
		})
	}

	weight, err := strconv.ParseFloat(c.FormValue("weight_pet"), 64)
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Berat tidak valid",
		})
	}

	// Buat instance Pet baru dan isi dengan data form
	pet := models.Pet{
		UserID:   userID,
		NamePet:  c.FormValue("name_pet"),
		TypePet:  c.FormValue("type_pet"),
		BreedPet: c.FormValue("breed_pet"),
		Sex:      c.FormValue("sex"),
		Weight:   weight,
		ColorPet: c.FormValue("color_pet"),
		ImagePet: "/uploads/" + filepath.Base(imagePath), 
	}

	// Simpan data pet ke database
	query := "INSERT INTO pet (id_user, name_pet, type_pet, breed_pet, sex, weight_pet, color_pet, image_pet) VALUES (?, ?, ?, ?, ?, ?, ?, ?)"
	result, err := petService.DB.Exec(query, pet.UserID, pet.NamePet, pet.TypePet, pet.BreedPet, pet.Sex, pet.Weight, pet.ColorPet, pet.ImagePet)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal membuat data pet",
		})
	}

	// Ambil ID yang baru dimasukkan
	id, err := result.LastInsertId()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal mengambil ID terakhir yang dimasukkan",
		})
	}
	pet.IDPet = int(id)

	return c.Status(fiber.StatusCreated).JSON(pet)
}

// GetDataPet mendapatkan semua entri pet
func (petService *PetService) GetDataPet() ([]*models.Pet, error) {
	var pets []*models.Pet
	query := "SELECT id_pet, id_user, name_pet, type_pet, breed_pet, sex, weight_pet, color_pet, image_pet FROM pet"
	rows, err := petService.DB.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		pet := &models.Pet{}
		err := rows.Scan(&pet.IDPet, &pet.UserID, &pet.NamePet, &pet.TypePet, &pet.BreedPet, &pet.Sex, &pet.Weight, &pet.ColorPet, &pet.ImagePet)
		if err != nil {
			return nil, err
		}

		// Ubah URL gambar
		pet.ImagePet = "/uploads/" + filepath.Base(pet.ImagePet)

		pets = append(pets, pet)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return pets, nil
}

// GetPetsByUserID mengambil semua data pet berdasarkan id_user
func (petService *PetService) GetPetsByUserID(userID int) ([]*models.Pet, error) {
	var pets []*models.Pet
	query := "SELECT id_pet, id_user, name_pet, type_pet, breed_pet, sex, weight_pet, color_pet, image_pet FROM pet WHERE id_user = ?"
	rows, err := petService.DB.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		pet := &models.Pet{}
		err := rows.Scan(&pet.IDPet, &pet.UserID, &pet.NamePet, &pet.TypePet, &pet.BreedPet, &pet.Sex, &pet.Weight, &pet.ColorPet, &pet.ImagePet)
		if err != nil {
			return nil, err
		}

		// Ubah URL gambar
		pet.ImagePet = fmt.Sprintf("http://%s:%d/uploads/%s", petService.Hostname, petService.Port, filepath.Base(pet.ImagePet))

		pets = append(pets, pet)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return pets, nil
}

// GetPetByID mendapatkan entri Pet berdasarkan ID
func (petService *PetService) GetPetByID(id int) (*models.Pet, error) {
	pet := &models.Pet{}
	query := "SELECT id_pet, id_user, name_pet, type_pet, breed_pet, sex, weight_pet, color_pet, image_pet FROM pet WHERE id_pet = ?"
	err := petService.DB.QueryRow(query, id).Scan(&pet.IDPet, &pet.UserID, &pet.NamePet, &pet.TypePet, &pet.BreedPet, &pet.Sex, &pet.Weight, &pet.ColorPet, &pet.ImagePet)
	if err != nil {
		return nil, err
	}

	// Ubah URL gambar
	pet.ImagePet = fmt.Sprintf("http://%s:%d/uploads/%s", petService.Hostname, petService.Port, filepath.Base(pet.ImagePet))

	return pet, nil
}

// DeletePet menghapus entri Pet berdasarkan ID
func (petService *PetService) DeletePet(id int) error {
	query := "DELETE FROM pet WHERE id_pet = ?"
	result, err := petService.DB.Exec(query, id)
	if err != nil {
		return err
	}
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rowsAffected == 0 {
		return errors.New("pet tidak ditemukan")
	}
	return nil
}

// UpdatePetData memperbarui data pet
func (petService *PetService) UpdatePetData(c *fiber.Ctx) error {
	// Ambil ID pet dari parameter URL
	idStr := c.Params("id")
	log.Println("id_pet value from URL:", idStr)
	id, err := strconv.Atoi(idStr)
	if err != nil {
		log.Println("Error converting id_pet from URL:", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID pet tidak valid",
		})
	}

	// Parse data form
	form, err := c.MultipartForm()
	if err != nil {
		log.Println("Failed to parse form data:", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Gagal memproses data form",
		})
	}

	files := form.File["image_pet"]
	var file *multipart.FileHeader
	if len(files) > 0 {
		// Asumsikan hanya ada satu file yang diunggah
		file = files[0]
	}

	// Log semua nilai form untuk debugging
	for key, values := range form.Value {
		log.Println("Form value:", key, values)
	}

	userIDStr := c.FormValue("id_user")
	log.Println("id_user value:", userIDStr)
	userID, err := strconv.Atoi(userIDStr)
	if err != nil {
		log.Println("Error converting id_user:", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID pengguna tidak valid",
		})
	}

	weightStr := c.FormValue("weight_pet")
	log.Println("weight_pet value:", weightStr)
	weight, err := strconv.ParseFloat(weightStr, 64)
	if err != nil {
		log.Println("Error converting weight_pet:", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Berat tidak valid",
		})
	}

	// Periksa apakah pet ada
	existingPet, err := petService.GetPetByID(id)
	if err != nil {
		log.Println("Error retrieving pet by ID:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal mengambil data pet",
		})
	}
	if existingPet == nil {
		log.Println("Pet not found with ID:", id)
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "Pet tidak ditemukan",
		})
	}

	// Perbarui data pet
	pet := &models.Pet{
		IDPet:    id,
		UserID:   userID,
		NamePet:  c.FormValue("name_pet"),
		TypePet:  c.FormValue("type_pet"),
		BreedPet: c.FormValue("breed_pet"),
		Sex:      c.FormValue("sex"),
		Weight:   weight,
		ColorPet: c.FormValue("color_pet"),
	}

	// Perbarui gambar jika ada gambar baru yang disediakan
	if file != nil {
		imagePath, err := petService.saveImagePetUpdate(file)
		if err != nil {
			log.Println("Error saving image:", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"error": "Gagal menyimpan gambar",
			})
		}
		pet.ImagePet = "/uploads/" + filepath.Base(imagePath)
	} else {
		// Jika tidak ada gambar baru yang disediakan, pertahankan yang lama
		pet.ImagePet = existingPet.ImagePet
	}

	// Perbarui data pet di database
	_, err = petService.DB.Exec("UPDATE pet SET id_user=?, name_pet=?, type_pet=?, breed_pet=?, sex=?, weight_pet=?, color_pet=?, image_pet=? WHERE id_pet=?", pet.UserID, pet.NamePet, pet.TypePet, pet.BreedPet, pet.Sex, pet.Weight, pet.ColorPet, pet.ImagePet, pet.IDPet)
	if err != nil {
		log.Println("Error updating pet:", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal memperbarui data pet",
		})
	}

	return c.JSON(pet)
}

// saveImagePetUpdate menyimpan file gambar pet dan mengembalikan URL gambar yang disimpan
func (petService *PetService) saveImagePetUpdate(file *multipart.FileHeader) (string, error) {
	src, err := file.Open()
	if err != nil {
		return "", err
	}
	defer src.Close()

	// Buat hash dari file
	hash := sha256.New()
	if _, err := io.Copy(hash, src); err != nil {
		return "", err
	}
	hashSum := fmt.Sprintf("%x", hash.Sum(nil))

	// Set path untuk menyimpan gambar
	dstPath := filepath.Join("uploads", hashSum+filepath.Ext(file.Filename))

	// Buat direktori jika belum ada
	if err := os.MkdirAll(filepath.Dir(dstPath), 0755); err != nil {
		return "", err
	}

	// Salin file ke lokasi tujuan
	dst, err := os.Create(dstPath)
	if err != nil {
		return "", err
	}
	defer dst.Close()

	if _, err := src.Seek(0, io.SeekStart); err != nil {
		return "", err
	}
	if _, err := io.Copy(dst, src); err != nil {
		return "", err
	}

	return "/" + dstPath, nil
}
