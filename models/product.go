package models

type Product struct {
	ID           int    `json:"id_product"`
	NameProduct  string `json:"name_product"`
	Description  string `json:"description"`
	Price        int    `json:"price"`
	ImageProduct string `json:"image_product"`
}
