package models

type TaskUser struct {
    ID          int    `json:"id_task"`
    UserID      int    `json:"id_user"`
    PetID       int    `json:"id_pet"`
    Category    string `json:"category"`
    Date        string `json:"date"`
    Description string `json:"description"`
    IsDone      int    `json:"is_done"`
}