package main

import (
	"API_DoCa/config"
	"API_DoCa/handlers"
	"API_DoCa/services"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
	// Menghubungkan ke database
	config.ConnectDatabase()

	app := fiber.New()

	// Middleware CORS
	app.Use(cors.New(cors.Config{
		AllowOrigins:     "http://localhost:8000, http://192.168.61.42:8000",
		AllowMethods:     "GET, POST, PUT, DELETE",
		AllowHeaders:     "Authorization, Content-Type",
		AllowCredentials: true,
	}))

	// Membuat instance UserService dengan koneksi database
	userService := &services.UserService{
		DB:       config.DB,
		Hostname: "192.168.61.42",
		Port:     8000,
	}

	// Membuat instance UserHandler
	userHandler := &handlers.UserHandler{
		UserService: userService,
	}

	productService := &services.ProductService{
		DB: config.DB,
	}

	// Membuat instance ProductHandler
	productHandler := &handlers.ProductHandler{
		ProductService: productService,
	}

	petService := &services.PetService{
		DB:       config.DB,
		Hostname: "192.168.61.42",
		Port:     8000,
	}

	// Membuat instance PetHandler
	petHandler := &handlers.PetHandler{
		PetService: petService,
	}

	taskUserService := &services.TaskUserService{
		DB: config.DB,
	}

	// Membuat instance PetHandler
	taskUserHandler := &handlers.TaskUserHandler{
		TaskUserService: taskUserService,
	}

	// Endpoint untuk user
	app.Post("/login", userHandler.LoginHandler)
	app.Post("/register", userHandler.RegisterHandler)
	app.Get("/uploads/:image", userHandler.ImageHandler)
	app.Post("/logout", userHandler.LogoutHandler)
	app.Put("/update-user/:id_user", userHandler.UpdateDataUserHandler)
	app.Put("/users/:id", userHandler.UpdateDataUserHandler)
	app.Get("/users/:id", userHandler.GetUserByIDHandler)

	//Endpoint untuk produk
	app.Post("/products", productHandler.CreateProductHandler)
	app.Get("/products/:id", productHandler.GetProductByIDHandler)
	app.Get("/products", productHandler.GetProductsHandler)
	app.Delete("/products/:id", productHandler.DeleteProductHandler)
	app.Put("products/:id", productHandler.UpdateProductHandler)

	//Endpoint untuk pet
	app.Post("/addDataPet", petHandler.CreatePetHandler)
	app.Get("/getDataPet", petHandler.GetPetHandler)
	app.Get("/getDataPet/:id", petHandler.GetPetByIDHandler)
	app.Delete("/deleteDataPet/:id", petHandler.DeletePetHandler)
	app.Put("/updatePetData/:id", petHandler.UpdatePetDataHandler)
	app.Get("/getDataPetByUserID/:id_user", petHandler.GetPetsByUserIDHandler)

	// Endpoint untuk task
	app.Post("/addTaskUser", taskUserHandler.CreateTaskHandler)
	app.Get("/getTaskUser", taskUserHandler.GetTaskUser)
	app.Get("/getTaskUser/:id", taskUserHandler.GetTaskUserByID)
	app.Delete("/deleteTaskUser/:id", taskUserHandler.DeleteTaskUser)
	app.Put("/updateTaskUser/:id", taskUserHandler.UpdateTaskHandler)
	app.Get("/getDataTaskByPetID/:id", taskUserHandler.GetTaskUserByPetID)
	app.Put("/tasks/:id/done", taskUserService.UpdateTaskDone)

	//mengatur port nya
	app.Listen(":8000")
}