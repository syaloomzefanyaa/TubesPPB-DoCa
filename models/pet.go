package models

type Pet struct {
    IDPet    int     `json:"id_pet"`
    UserID   int     `json:"id_user"`
    NamePet  string  `json:"name_pet"`
    TypePet  string  `json:"type_pet"`
    BreedPet string  `json:"breed_pet"`
    Sex      string  `json:"sex"`
    Weight   float64 `json:"weight_pet"`
    ColorPet string  `json:"color_pet"`
    ImagePet string  `json:"image_pet"`
}
