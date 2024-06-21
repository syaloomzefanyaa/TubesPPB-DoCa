package models

type User struct {
    ID       int    `json:"id_user"`
    Username string `json:"username"`
    Email    string `json:"email"`
    Password string `json:"password"`
    Image    string `json:"image"` 
    ImagePath string `json:"image_path"`
    IsLogin  int    `json:"isLogin"`
}
