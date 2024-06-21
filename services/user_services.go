package services

import (
    "database/sql"
    "errors"
    "API_DoCa/models"
    "path/filepath"
    "fmt"
    "os"
    "io"
    "mime/multipart"
    "crypto/sha256"
    "github.com/gofiber/fiber/v2"
    "log"
    "strconv"
)

type UserService struct {
    DB *sql.DB
    Hostname string
    Port     int
}

func (s *UserService) Register(username, email, password string) (*models.User, error) {
    // Mengecek inputan dari user, jika kosong akan mengembalikan error
    if username == "" || email == "" || password == "" {
        return nil, errors.New("username, email, dan password harus diisi")
    }

    // Mengecek apakah email sudah terdaftar sebelumnya
    var count int
    err := s.DB.QueryRow("SELECT COUNT(*) FROM user WHERE email = ?", email).Scan(&count)
    if err != nil {
        return nil, err
    }
    if count > 0 {
        return nil, errors.New("email sudah terdaftar")
    }

    // Menambahkan pengguna ke dalam database
    res, err := s.DB.Exec("INSERT INTO user (username, email, password, isLogin) VALUES (?, ?, ?, ?)", username, email, password, 1)
    if err != nil {
        return nil, err
    }

    // Mengambil ID dari pengguna yang baru ditambahkan
    id, err := res.LastInsertId()
    if err != nil {
        return nil, err
    }

    // Jika berhasil, kembalikan data pengguna yang baru terdaftar
    newUser := &models.User{
        ID:       int(id),
        Username: username,
        Email:    email,
        Password: password,
    }
    return newUser, nil
}

// Fungsi login
func (s *UserService) Login(email, password string) (*models.User, error) {
    var user models.User
    // Mengecek data pada tabel
    err := s.DB.QueryRow("SELECT id_user, username, email, password, image, isLogin FROM user WHERE email = ?", email).Scan(&user.ID, &user.Username, &user.Email, &user.Password, &user.Image, &user.IsLogin)
    if err != nil {
        if errors.Is(err, sql.ErrNoRows) {
            return nil, errors.New("pengguna tidak ditemukan")
        }
        return nil, err
    }

    // Mengatasi password yang tidak sesuai
    if user.Password != password {
        return nil, errors.New("password salah")
    }

    // Mengupdate status isLogin
    if user.IsLogin == 2 {
        _, err = s.DB.Exec("UPDATE user SET isLogin = 1 WHERE id_user = ?", user.ID)
        if err != nil {
            return nil, err
        }
        user.IsLogin = 1
    }

    // Password tidak akan ditampilkan
    user.Password = ""
    
    // Mengisi return ImagePath dari Image
    user.ImagePath = fmt.Sprintf("http://%s:%d/uploads/%s", s.Hostname, s.Port, filepath.Base(user.Image))

    return &user, nil
}

// Fungsi Logout untuk mengubah status isLogin dari 1 menjadi 2
func (s *UserService) Logout(userID int) error {
    // Update isLogin dari 1 menjadi 2 berdasarkan user ID
    result, err := s.DB.Exec("UPDATE user SET isLogin = 2 WHERE id_user = ? AND isLogin = 1", userID)
    if err != nil {
        return err
    }

    // Periksa apakah ada baris yang diupdate
    rowsAffected, err := result.RowsAffected()
    if err != nil {
        return err
    }
    if rowsAffected == 0 {
        return errors.New("user tidak ditemukan atau sudah logout")
    }

    return nil
}

// GetUserByID mengambil data pengguna berdasarkan ID-nya
func (userService *UserService) GetUserByID(userID int) (*models.User, error) {
    var user models.User
    err := userService.DB.QueryRow("SELECT id_user, username, email, image, isLogin FROM user WHERE id_user = ?", userID).Scan(&user.ID, &user.Username, &user.Email, &user.Image, &user.IsLogin)
    if err != nil {
        if errors.Is(err, sql.ErrNoRows) {
            return nil, errors.New("pengguna tidak ditemukan")
        }
        return nil, err
    }
    return &user, nil
}

func (s *UserService) UpdateDataUser(c *fiber.Ctx) error {
    // Mengambil user ID dari URL parameter
    idStr := c.Params("id")
    log.Println("id_user value dari URL:", idStr)
    id, err := strconv.Atoi(idStr)
    if err != nil {
        log.Println("Error mengubah id_user dari URL:", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "user ID tidak ada",
        })
    }

    form, err := c.MultipartForm()
    if err != nil {
        log.Println("Gagal memasukan data:", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "data gagal dimasukan ke kolomnya",
        })
    }

    files := form.File["image"]
    var file *multipart.FileHeader
    if len(files) > 0 {
        file = files[0]
    }

    // Mencetak semua inputan ke console
    for key, values := range form.Value {
        log.Println("bentuk formnya:", key, values)
    }

    username := form.Value["username"]
    email := form.Value["email"]

    // Mengecek apakah user ada pada database
    existingUser, err := s.GetUserByID(id)
    if err != nil {
        log.Println("gagal mengambil data user by ID:", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "gagal mengambil data user.",
        })
    }
    if existingUser == nil {
        log.Println("User tidak ditemukan dengan ID:", id)
        return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
            "error": "User tidak ditemukan",
        })
    }

    // Update data pengguna
    user := &models.User{
        ID:       id,
        Username: username[0],
        Email:    email[0],
        Image:    existingUser.Image,
    }

    // Update gambar jika gambar baru disediakan
    if file != nil {
        imagePath, err := s.saveImage(file)
        if err != nil {
            log.Println("Error menyimpan gambar:", err)
            return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
                "error": "Gagal menyimpan gambar",
            })
        }
        user.Image = "/uploads/" + filepath.Base(imagePath)
    }

    // Update data pengguna di database
    _, err = s.DB.Exec("UPDATE user SET username=?, email=?, image=? WHERE id_user=?", user.Username, user.Email, user.Image, user.ID)
    if err != nil {
        log.Println("Error mengupdate pengguna:", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mengupdate pengguna",
        })
    }

    return c.JSON(user)
}

func (s *UserService) saveImage(file *multipart.FileHeader) (string, error) {
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
