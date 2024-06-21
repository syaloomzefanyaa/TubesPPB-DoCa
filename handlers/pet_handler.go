package handlers

import (
	"API_DoCa/services"
	"github.com/gofiber/fiber/v2"
	"strconv"
)

type PetHandler struct {
	PetService *services.PetService 
}

func (handler *PetHandler) CreatePetHandler(c *fiber.Ctx) error {
	return handler.PetService.CreatePetData(c)
}

// GetProductsHandler mendapatkan semua entri produk
func (handler *PetHandler) GetPetHandler(c *fiber.Ctx) error {
	pet, err := handler.PetService.GetDataPet()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "tidak dapat mengambil produk",
		})
	}

	// Mengembalikan data produk yang berhasil diambil
	return c.Status(fiber.StatusOK).JSON(pet)
}

// GetPetByIDHandler mendapatkan entri pet berdasarkan ID
func (handler *PetHandler) GetPetByIDHandler(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID pet tidak valid",
		})
	}

	pet, err := handler.PetService.GetPetByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "pet tidak ditemukan",
		})
	}

	// Mengembalikan data pet yang berhasil diambil
	return c.Status(fiber.StatusOK).JSON(pet)
}

// DeletePetHandler menangani permintaan untuk menghapus entri pet berdasarkan ID
func (handler *PetHandler) DeletePetHandler(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID pet tidak valid",
		})
	}

	err = handler.PetService.DeletePet(id)
	if err != nil {
		if err.Error() == "pet tidak ditemukan" {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "pet tidak ditemukan",
			})
		}
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": err.Error(),
		})
	}

	return c.JSON(fiber.Map{
		"message": "Data berhasil dihapus",
	})
}

// UpdatePetDataHandler adalah handler untuk memperbarui data pet
func (handler *PetHandler) UpdatePetDataHandler(c *fiber.Ctx) error {
	return handler.PetService.UpdatePetData(c)
}

// GetPetsByUserIDHandler adalah handler untuk mengambil data pet berdasarkan id_user
func (handler *PetHandler) GetPetsByUserIDHandler(c *fiber.Ctx) error {
	userID, err := strconv.Atoi(c.Params("id_user"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID pengguna tidak valid",
		})
	}

	pets, err := handler.PetService.GetPetsByUserID(userID)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "Gagal mengambil hewan peliharaan",
		})
	}

	return c.Status(fiber.StatusOK).JSON(pets)
}
