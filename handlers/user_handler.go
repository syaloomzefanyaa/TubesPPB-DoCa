package handlers

import (
    "github.com/gofiber/fiber/v2"
    "API_DoCa/services"
    "strconv"
)

type UserHandler struct {
    UserService *services.UserService
}

// RegisterHandler adalah handler untuk endpoint registrasi pengguna
func (handler *UserHandler) RegisterHandler(c *fiber.Ctx) error {
    // Mendeklarasikan struktur credentials untuk menyimpan data dari permintaan
    var credentials struct {
        Username string `json:"username"`
        Email    string `json:"email"`
        Password string `json:"password"`
    }

    // Parsing data dari body permintaan ke dalam struktur credentials
    if err := c.BodyParser(&credentials); err != nil {
        // Jika parsing gagal, kembalikan pesan kesalahan dalam bentuk JSON
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"message": "Invalid request payload"})
    }
    
    // Panggil Register dari UserService dengan menggunakan data dari credentials
    newUser, err := handler.UserService.Register(credentials.Username, credentials.Email, credentials.Password)
    if err != nil {
        // Jika terjadi kesalahan, kembalikan pesan kesalahan dalam bentuk JSON
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"message": err.Error()})
    }
    
    // Jika berhasil, kembalikan data pengguna dalam bentuk JSON
    return c.JSON(newUser)
}

// LoginHandler adalah handler untuk endpoint login pengguna
func (handler *UserHandler) LoginHandler(c *fiber.Ctx) error {
    var credentials struct {
        Email    string `json:"email"`
        Password string `json:"password"`
    }

    if err := c.BodyParser(&credentials); err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"message": "Invalid request payload"})
    }

    user, err := handler.UserService.Login(credentials.Email, credentials.Password)
    if err != nil {
        return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{"message": err.Error()})
    }

    // Membuat response/return data pengguna
    response := struct {
        ID       int    `json:"id_user"`
        Username string `json:"username"`
        Email    string `json:"email"`
        IsLogin  int    `json:"isLogin"`
        ImagePath string `json:"image_path"`
    }{
        ID:        user.ID,
        Username:  user.Username,
        Email:     user.Email,
        IsLogin:   user.IsLogin,
        ImagePath: user.ImagePath,
    }

    return c.JSON(response)
}

// ImageHandler adalah handler untuk mengakses gambar
func (handler *UserHandler) ImageHandler(c *fiber.Ctx) error {
    image := c.Params("image")
    return c.SendFile("./uploads/" + image)
}

// Handler untuk endpoint logout pengguna
func (handler *UserHandler) LogoutHandler(c *fiber.Ctx) error {
    // Ambil userID dari form-data
    userIDStr := c.FormValue("id_user")
    if userIDStr == "" {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"message": "id_user is required"})
    }

    // Konversi userID ke int
    userID, err := strconv.Atoi(userIDStr)
    if err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"message": "Invalid id_user"})
    }

    // Panggil fungsi Logout dari UserService dengan menggunakan userID
    err = handler.UserService.Logout(userID)
    if err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"message": err.Error()})
    }

    return c.JSON(fiber.Map{"message": "Logout berhasil"})
}

// UpdateDataUserHandler adalah handler untuk memperbarui data pengguna
func (handler *UserHandler) UpdateDataUserHandler(c *fiber.Ctx) error {
    return handler.UserService.UpdateDataUser(c)
}

// GetUserByIDHandler adalah handler untuk mendapatkan data pengguna berdasarkan ID
func (handler *UserHandler) GetUserByIDHandler(c *fiber.Ctx) error {
    userIDStr := c.Params("id")
    userID, err := strconv.Atoi(userIDStr)
    if err != nil {
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{"error": "Invalid user ID"})
    }

    user, err := handler.UserService.GetUserByID(userID)
    if err != nil {
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{"error": err.Error()})
    }

    return c.JSON(user)
}
