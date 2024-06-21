package handlers

import (
	"API_DoCa/models"
	"API_DoCa/services"
	"github.com/gofiber/fiber/v2"
	"strconv"
)

// ProductHandler adalah handler untuk operasi terkait produk
type ProductHandler struct {
	ProductService *services.ProductService
}

// CreateProductHandler menangani permintaan untuk membuat entri produk baru
func (handler *ProductHandler) CreateProductHandler(c *fiber.Ctx) error {
	return handler.ProductService.CreateProduct(c)
}

// GetProductsHandler mendapatkan semua entri product
func (handler *ProductHandler) GetProductsHandler(c *fiber.Ctx) error {
	products, err := handler.ProductService.GetProducts()
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "gak bisa mengambil product",
		})
	}

	// Mengembalikan data produk yang berhasil diambil
	return c.Status(fiber.StatusOK).JSON(products)
}

// GetProductByIDHandler mendapatkan entri product berdasarkan ID
func (handler *ProductHandler) GetProductByIDHandler(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid produk ID",
		})
	}

	product, err := handler.ProductService.GetProductByID(id)
	if err != nil {
		return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
			"error": "produk tidak ditemukan",
		})
	}

	// Mengembalikan data produk yang berhasil diambil
	return c.Status(fiber.StatusOK).JSON(product)
}

// UpdateProductHandler menangani permintaan untuk mengupdate entri produk berdasarkan ID
func (handler *ProductHandler) UpdateProductHandler(c *fiber.Ctx) error {
	// Ambil ID produk dari URL
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "invalid produk ID",
		})
	}

	// Membuat objek produk dari data yang diterima
	var product models.Product
	if err := c.BodyParser(&product); err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "tidak dapat mengambil data dari JSON",
		})
	}
	product.ID = id // Set ID produk sesuai dengan ID yang diambil dari URL

	// Menerima file gambar dari permintaan
	file, err := c.FormFile("image_product")
	if err != nil && err != fiber.ErrUnprocessableEntity {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "tidak dapat mengambil data image_product",
		})
	}

	// Memanggil fungsi UpdateProduct dari ProductService untuk memperbarui produk
	updatedProduct, err := handler.ProductService.UpdateProduct(&product, file)
	if err != nil {
		return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
			"error": "tidak dapat mengupdate produk",
		})
	}

	// Mengembalikan respons sukses bersama dengan data produk yang baru diperbarui
	return c.Status(fiber.StatusOK).JSON(updatedProduct)
}

// DeleteProductHandler menangani permintaan untuk menghapus entri produk berdasarkan ID
func (handler *ProductHandler) DeleteProductHandler(c *fiber.Ctx) error {
	id, err := strconv.Atoi(c.Params("id"))
	if err != nil {
		return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
			"error": "ID produk tidak valid",
		})
	}

	err = handler.ProductService.DeleteProduct(id)
	if err != nil {
		if err.Error() == "produk tidak ditemukan" {
			return c.Status(fiber.StatusNotFound).JSON(fiber.Map{
				"error": "produk tidak ditemukan",
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
