package services

import (
    "API_DoCa/models"
    "database/sql"
    "log"
    "strconv"

    "github.com/gofiber/fiber/v2"
)

type TaskUserService struct {
    DB *sql.DB
}

func (service *TaskUserService) CreateTask(c *fiber.Ctx) error {
    // Konversi nilai form ke tipe yang sesuai
    userIDStr := c.FormValue("id_user")
    userID, err := strconv.Atoi(userIDStr)
    if err != nil {
        log.Printf("Gagal mengubah user ID menjadi integer: %v", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "ID pengguna tidak valid",
        })
    }

    petIDStr := c.FormValue("id_pet")
    petID, err := strconv.Atoi(petIDStr)
    if err != nil {
        log.Printf("Gagal mengubah pet ID menjadi integer: %v", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "ID hewan peliharaan tidak valid",
        })
    }

    // Set nilai default untuk is_done
    isDone := 2

    // Buat instance TaskUser baru dan isi dengan data dari form
    task := models.TaskUser{
        UserID:      userID,
        PetID:       petID,
        Category:    c.FormValue("category"),
        Date:        c.FormValue("date"),
        Description: c.FormValue("description"),
        IsDone:      isDone,
    }

    // Masukkan data tugas ke database
    query := "INSERT INTO task_user (id_user, id_pet, category, date, description, is_done) VALUES (?, ?, ?, ?, ?, ?)"
    result, err := service.DB.Exec(query, task.UserID, task.PetID, task.Category, task.Date, task.Description, task.IsDone)
    if err != nil {
        log.Printf("Gagal memasukkan tugas: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal membuat tugas",
        })
    }

    // Ambil ID yang baru dimasukkan
    id, err := result.LastInsertId()
    if err != nil {
        log.Printf("Gagal mengambil ID yang baru dimasukkan: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mengambil ID yang baru dimasukkan",
        })
    }
    task.ID = int(id)

    // Log informasi tentang tugas yang dibuat
    log.Printf("Membuat tugas dengan ID %d, UserID: %d, PetID: %d, Kategori: %s, Tanggal: %s, Deskripsi: %s, IsDone: %d\n",
        task.ID, task.UserID, task.PetID, task.Category, task.Date, task.Description, task.IsDone)

    return c.Status(fiber.StatusCreated).JSON(task)
}

func (service *TaskUserService) GetTaskUser(c *fiber.Ctx) error {
    tasks := []*models.TaskUser{}

    query := "SELECT id_task, id_user, id_pet, category, date, description, is_done FROM task_user"
    rows, err := service.DB.Query(query)
    if err != nil {
        log.Printf("Gagal mengambil tugas: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mengambil tugas",
        })
    }
    defer rows.Close()

    for rows.Next() {
        task := &models.TaskUser{}
        err := rows.Scan(&task.ID, &task.UserID, &task.PetID, &task.Category, &task.Date, &task.Description, &task.IsDone)
        if err != nil {
            log.Printf("Gagal memindai tugas: %v", err)
            return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
                "error": "Gagal memindai tugas",
            })
        }
        tasks = append(tasks, task)
    }

    return c.Status(fiber.StatusOK).JSON(tasks)
}

func (service *TaskUserService) GetTaskUserByID(c *fiber.Ctx) error {
    id := c.Params("id")
    task := &models.TaskUser{}

    query := "SELECT id_task, id_user, id_pet, category, date, description, is_done FROM task_user WHERE id_task = ?"
    err := service.DB.QueryRow(query, id).Scan(&task.ID, &task.UserID, &task.PetID, &task.Category, &task.Date, &task.Description, &task.IsDone)
    if err != nil {
        log.Printf("Gagal mengambil tugas berdasarkan ID: %v", err)
        return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
            "error": "Tugas tidak ditemukan",
        })
    }

    return c.Status(fiber.StatusOK).JSON(task)
}

func (service *TaskUserService) DeleteTaskUser(c *fiber.Ctx) error {
    id := c.Params("id")

    query := "DELETE FROM task_user WHERE id_task = ?"
    result, err := service.DB.Exec(query, id)
    if err != nil {
        log.Printf("Gagal menghapus tugas: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal menghapus tugas",
        })
    }

    rowsAffected, err := result.RowsAffected()
    if err != nil {
        log.Printf("Gagal mendapatkan jumlah baris yang terpengaruh: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mendapatkan jumlah baris yang terpengaruh",
        })
    }
    if rowsAffected == 0 {
        return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
            "error": "Tugas tidak ditemukan",
        })
    }

    return c.Status(fiber.StatusOK).JSON(fiber.Map{
        "message": "Data berhasil dihapus",
    })
}

func (service *TaskUserService) UpdateTaskUser(c *fiber.Ctx) error {
    // Ambil ID dari parameter URL
    idStr := c.Params("id")
    id, err := strconv.Atoi(idStr)
    if err != nil {
        log.Printf("Gagal mengubah task ID menjadi integer: %v", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "ID tugas tidak valid",
        })
    }

    // Konversi nilai form ke tipe yang sesuai
    userIDStr := c.FormValue("id_user")
    userID, err := strconv.Atoi(userIDStr)
    if err != nil {
        log.Printf("Gagal mengubah user ID menjadi integer: %v", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "ID pengguna tidak valid",
        })
    }

    petIDStr := c.FormValue("id_pet")
    petID, err := strconv.Atoi(petIDStr)
    if err != nil {
        log.Printf("Gagal mengubah pet ID menjadi integer: %v", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "ID hewan peliharaan tidak valid",
        })
    }

    // Buat instance TaskUser baru dan isi dengan data dari form
    task := models.TaskUser{
        ID:          id,
        UserID:      userID,
        PetID:       petID,
        Category:    c.FormValue("category"),
        Date:        c.FormValue("date"),
        Description: c.FormValue("description"),
        IsDone:      2, // Set nilai is_done menjadi 2
    }

    // Update data tugas di database
    query := "UPDATE task_user SET id_user = ?, id_pet = ?, category = ?, date = ?, description = ?, is_done = ? WHERE id_task = ?"
    _, err = service.DB.Exec(query, task.UserID, task.PetID, task.Category, task.Date, task.Description, task.IsDone, task.ID)
    if err != nil {
        log.Printf("Gagal mengupdate tugas: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mengupdate tugas",
        })
    }

    // Log informasi tentang tugas yang diupdate
    log.Printf("Mengupdate tugas dengan ID %d, UserID: %d, PetID: %d, Kategori: %s, Tanggal: %s, Deskripsi: %s, IsDone: %d\n",
        task.ID, task.UserID, task.PetID, task.Category, task.Date, task.Description, task.IsDone)

    return c.Status(fiber.StatusOK).JSON(task)
}

func (service *TaskUserService) GetTaskUserByPetID(c *fiber.Ctx) error {
    id := c.Params("id")
    tasks := []*models.TaskUser{}

    query := "SELECT id_task, id_user, id_pet, category, date, description, is_done FROM task_user WHERE id_pet = ?"
    rows, err := service.DB.Query(query, id)
    if err != nil {
        log.Printf("Gagal mengambil tugas: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mengambil tugas",
        })
    }
    defer rows.Close()

    for rows.Next() {
        task := &models.TaskUser{}
        err := rows.Scan(&task.ID, &task.UserID, &task.PetID, &task.Category, &task.Date, &task.Description, &task.IsDone)
        if err != nil {
            log.Printf("Gagal memindai tugas: %v", err)
            return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
                "error": "Gagal memindai tugas",
            })
        }
        tasks = append(tasks, task)
    }

    return c.Status(fiber.StatusOK).JSON(tasks)
}

func (service *TaskUserService) UpdateTaskDone(c *fiber.Ctx) error {
    // Ambil ID dari parameter URL
    idStr := c.Params("id")
    id, err := strconv.Atoi(idStr)
    if err != nil {
        log.Printf("Gagal mengubah task ID menjadi integer: %v", err)
        return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
            "error": "ID tugas tidak valid",
        })
    }

    // Update data tugas di database
    query := "UPDATE task_user SET is_done = 1 WHERE id_task = ? AND is_done = 2"
    result, err := service.DB.Exec(query, id)
    if err != nil {
        log.Printf("Gagal mengupdate tugas: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mengupdate tugas",
        })
    }

    // Periksa apakah ada baris yang terpengaruh
    rowsAffected, err := result.RowsAffected()
    if err != nil {
        log.Printf("Gagal mendapatkan jumlah baris yang terpengaruh: %v", err)
        return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
            "error": "Gagal mendapatkan jumlah baris yang terpengaruh",
        })
    }

    // Jika tidak ada baris yang terpengaruh, tugas dengan ID yang diberikan tidak ditemukan
    if rowsAffected == 0 {
        return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
            "error": "Tugas tidak ditemukan atau sudah selesai",
        })
    }

    // Log informasi tentang tugas yang diupdate
    log.Printf("Mengupdate tugas dengan ID %d, mengatur is_done menjadi 1\n", id)

    return c.Status(fiber.StatusOK).JSON(fiber.Map{
        "message": "Tugas ditandai sebagai selesai",
    })
}
