package services

import (
	"API_DoCa/models"
	"crypto/sha256"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"io"
	"mime/multipart"
	"os"
	"path/filepath"
	"strconv"
	"github.com/gofiber/fiber/v2"
)

// ProductService adalah layanan untuk operasi terkait produk
type ProductService struct {
	DB *sql.DB
}

// saveImageProduct menyimpan gambar dan mengembalikan URL gambar
func (productService *ProductService) saveImageProduct(file *multipart.FileHeader) (string, error) {
	src, err := file.Open()
	if err != nil {
		log.Printf("Gagal membuka file: %v", err)
		return "", err
	}
	defer src.Close()

	// Buat hash dari file
	hash := sha256.New()
	if _, err := io.Copy(hash, src); err != nil {
		log.Printf("Gagal menyalin hash: %v", err)
		return "", err
	}
	hashSum := fmt.Sprintf("%x", hash.Sum(nil))

	// Set path untuk menyimpan gambar
	dstPath := filepath.Join("uploads", hashSum+filepath.Ext(file.Filename))

	// Buat direktori jika belum ada
	if err := os.MkdirAll(filepath.Dir(dstPath), 0755); err != nil {
		log.Printf("Gagal membuat direktori: %v", err)
		return "", err
	}

	// Salin file ke lokasi tujuan
	dst, err := os.Create(dstPath)
	if err != nil {
		log.Printf("Gagal membuat file tujuan: %v", err)
		return "", err
	}
	defer dst.Close()

	if _, err := src.Seek(0, io.SeekStart); err != nil {
		log.Printf("Gagal mencari file sumber: %v", err)
		return "", err
	}
	if _, err := io.Copy(dst, src); err != nil {
		log.Printf("Gagal menyalin ke tujuan: %v", err)
		return "", err
	}

	log.Printf("Gambar disimpan ke %s", dstPath)
	return "/" + dstPath, nil
}

// CreateProduct membuat entri baru di tabel product
func (productService *ProductService) CreateProduct(c *fiber.Ctx) error {
	// Parse form data
	form, err := c.MultipartForm()
	if err != nil {
		log.Printf("Gagal memparse data form: %v", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Gagal memparse data form",
		})
	}

	// Menerima file gambar dari permintaan
	files := form.File["image_product"]
	if len(files) == 0 {
		log.Print("Gambar diperlukan")
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Gambar diperlukan",
		})
	}

	// Asumsikan hanya ada satu file yang diunggah
	file := files[0]

	// Simpan gambar menggunakan fungsi saveImageProduct
	imagePath, err := productService.saveImageProduct(file)
	if err != nil {
		log.Printf("Gagal menyimpan gambar: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal menyimpan gambar",
		})
	}

	// Konversi nilai form ke tipe yang sesuai
	price, err := strconv.Atoi(form.Value["price"][0])
	if err != nil {
		log.Printf("Harga tidak valid: %v", err)
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "Harga tidak valid",
		})
	}

	// Buat instance Product baru dan isi dengan data dari form
	product := &models.Product{
		NameProduct:  form.Value["name_product"][0],
		Description:  form.Value["description"][0],
		Price:        price,
		ImageProduct: "/uploads/" + filepath.Base(imagePath),
	}

	// Masukkan data produk ke dalam database
	query := "INSERT INTO product (name_product, description, price, image_product) VALUES (?, ?, ?, ?)"
	result, err := productService.DB.Exec(query, product.NameProduct, product.Description, product.Price, product.ImageProduct)
	if err != nil {
		log.Printf("Gagal memasukkan produk: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal memasukkan produk",
		})
	}

	// Ambil ID produk yang baru saja ditambahkan
	id, err := result.LastInsertId()
	if err != nil {
		log.Printf("Gagal mendapatkan ID terakhir yang dimasukkan: %v", err)
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal mendapatkan ID terakhir yang dimasukkan",
		})
	}
	product.ID = int(id)

	// Log informasi produk yang dibuat
	log.Printf("Produk dibuat dengan ID %d, Nama: %s, Deskripsi: %s, Harga: %d, Gambar: %s\n",
		product.ID, product.NameProduct, product.Description, product.Price, product.ImageProduct)

	return c.Status(fiber.StatusCreated).JSON(product)
}

// GetProducts mendapatkan semua entri product
func (productService *ProductService) GetProducts() ([]*models.Product, error) {
	var products []*models.Product
	query := "SELECT id_product, name_product, description, price, image_product FROM product"
	rows, err := productService.DB.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		product := &models.Product{}
		err := rows.Scan(&product.ID, &product.NameProduct, &product.Description, &product.Price, &product.ImageProduct)
		if err != nil {
			return nil, err
		}

		// Ubah URL gambar
		product.ImageProduct = "/uploads/" + filepath.Base(product.ImageProduct)

		products = append(products, product)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	return products, nil
}

// GetProductByID mendapatkan entri product berdasarkan ID
func (productService *ProductService) GetProductByID(id int) (*models.Product, error) {
	product := &models.Product{}
	query := "SELECT id_product, name_product, description, price, image_product FROM product WHERE id_product = ?"
	err := productService.DB.QueryRow(query, id).Scan(&product.ID, &product.NameProduct, &product.Description, &product.Price, &product.ImageProduct)
	if err != nil {
		return nil, err
	}

	// Ubah URL gambar
	product.ImageProduct = "/uploads/" + filepath.Base(product.ImageProduct)

	return product, nil
}

// DeleteProduct menghapus entri product berdasarkan ID
func (productService *ProductService) DeleteProduct(id int) error {
	query := "DELETE FROM product WHERE id_product = ?"
	result, err := productService.DB.Exec(query, id)
	if err != nil {
		return err
	}
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}
	if rowsAffected == 0 {
		return errors.New("produk tidak ditemukan")
	}
	return nil
}

// saveImageProductUpdate menyimpan file gambar produk dan mengembalikan URL gambar yang disimpan
func (productService *ProductService) saveImageProductUpdate(file *multipart.FileHeader) (string, error) {
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

// UpdateProduct mengupdate entri produk dalam database
func (productService *ProductService) UpdateProduct(product *models.Product, file *multipart.FileHeader) (*models.Product, error) {
	// Simpan gambar produk baru jika ada
	if file != nil {
		// Simpan gambar produk baru
		imageURL, err := productService.saveImageProductUpdate(file)
		if err != nil {
			return nil, err
		}
		product.ImageProduct = "/uploads/" + filepath.Base(imageURL)
	}

	// Update data produk ke dalam database
	var query string
	var args []interface{}
	if file != nil {
		query = "UPDATE product SET name_product = ?, description = ?, price = ?, image_product = ? WHERE id_product = ?"
		args = []interface{}{product.NameProduct, product.Description, product.Price, product.ImageProduct, product.ID}
	} else {
		query = "UPDATE product SET name_product = ?, description = ?, price = ? WHERE id_product = ?"
		args = []interface{}{product.NameProduct, product.Description, product.Price, product.ID}
	}

	result, err := productService.DB.Exec(query, args...)
	if err != nil {
		return nil, err
	}

	// Periksa apakah data produk berhasil diupdate
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return nil, err
	}
	if rowsAffected == 0 {
		return nil, errors.New("produk tidak ditemukan")
	}

	return product, nil
}