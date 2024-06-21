package handlers

import (
    "github.com/gofiber/fiber/v2"
    "API_DoCa/services"
)

type TaskUserHandler struct {
    TaskUserService *services.TaskUserService
}

func (handler *TaskUserHandler) CreateTaskHandler(c *fiber.Ctx) error {
    return handler.TaskUserService.CreateTask(c)
}

func (handler *TaskUserHandler) GetTaskUser(c *fiber.Ctx) error {
	return handler.TaskUserService.GetTaskUser(c)
}

func (handler *TaskUserHandler) GetTaskUserByID(c *fiber.Ctx) error {
	return handler.TaskUserService.GetTaskUserByID(c)
}

func (handler *TaskUserHandler) DeleteTaskUser(c *fiber.Ctx) error {
	return handler.TaskUserService.DeleteTaskUser(c)
}

func (handler *TaskUserHandler) UpdateTaskHandler(c *fiber.Ctx) error {
    return handler.TaskUserService.UpdateTaskUser(c)
}

func (handler *TaskUserHandler) GetTaskUserByPetID(c *fiber.Ctx) error {
    return handler.TaskUserService.GetTaskUserByPetID(c)
}