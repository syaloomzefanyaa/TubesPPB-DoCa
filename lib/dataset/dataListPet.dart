class Pet {
  final int idPet;
  final int idUser;
  final String namePet;
  final String typePet;
  final String breedPet;
  final String sex;
  final double weightPet;
  final String colorPet;
  final List<String> imagePet;

  Pet({
    required this.idPet,
    required this.idUser,
    required this.namePet,
    required this.typePet,
    required this.breedPet,
    required this.sex,
    required this.weightPet,
    required this.colorPet,
    required this.imagePet,
  });
}

List<Pet> generatePetList() {
  return [
    Pet(
      idPet: 1,
      idUser: 101,
      namePet: 'Bella',
      typePet: 'Dog',
      breedPet: 'Golden Retriever',
      sex: 'Female',
      weightPet: 25.0,
      colorPet: 'Golden',
      imagePet: [
        'assets/images/pet/dog.jpg',
      ],
    ),
    Pet(
      idPet: 2,
      idUser: 102,
      namePet: 'Max',
      typePet: 'Cat',
      breedPet: 'Siamese',
      sex: 'Male',
      weightPet: 7.5,
      colorPet: 'Cream and Brown',
      imagePet: [
        'assets/images/pet/cat.jpg',
      ],
    ),
    Pet(
      idPet: 3,
      idUser: 103,
      namePet: 'Charlie',
      typePet: 'Fish',
      breedPet: 'redCattail Fish',
      sex: 'Male',
      weightPet: 0.9,
      colorPet: 'Grey and red',
      imagePet: [
        'assets/images/pet/ikan.jpg',
      ],
    ),
  ];
}
