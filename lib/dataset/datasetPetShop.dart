class Product {
  final int idProduct;
  final String nameProduct;
  final String description;
  final double price;
  final List<String> imageProduct;
  final String category;

  Product({
    required this.idProduct,
    required this.nameProduct,
    required this.description,
    required this.price,
    required this.imageProduct,
    required this.category,
  });
}

List<Product> generateProductList() {
  return [
    Product(
      idProduct: 1,
      nameProduct: 'Dog Food',
      description: 'High-quality dog food rich in nutrients.',
      price: 20.99,
      imageProduct: [
        'assets/images/PetShop/DogFood.png',
      ],
      category: 'Food',
    ),
    Product(
      idProduct: 2,
      nameProduct: 'Cat Food',
      description: 'Nutritious cat food for healthy growth.',
      price: 18.50,
      imageProduct: [
        'assets/images/PetShop/CatFood.jpg',
      ],
      category: 'Food',
    ),
    Product(
      idProduct: 3,
      nameProduct: 'Bird Cage',
      description: 'Spacious bird cage with multiple perches.',
      price: 45.99,
      imageProduct: [
        'assets/images/PetShop/BirdCage.jpg',
      ],
      category: 'Cage',
    ),
    Product(
      idProduct: 4,
      nameProduct: 'Fish Tank',
      description: '20-gallon fish tank with LED lighting.',
      price: 60.00,
      imageProduct: [
        'assets/images/PetShop/FishTank.jpg',
      ],
      category: 'Cage',
    ),
    Product(
      idProduct: 5,
      nameProduct: 'Dog Leash',
      description: 'Durable dog leash for safe walks.',
      price: 12.75,
      imageProduct: [
        'assets/images/PetShop/DogLeash.jpg',
      ],
      category: 'Equipment',
    ),
    Product(
      idProduct: 6,
      nameProduct: 'Cat Litter',
      description: 'Clumping cat litter with odor control.',
      price: 10.50,
      imageProduct: [
        'assets/images/PetShop/CatLitter.jpg',
      ],
      category: 'Equipment',
    ),
    Product(
      idProduct: 7,
      nameProduct: 'Bird Seed',
      description: 'Mixed bird seed for various bird species.',
      price: 8.99,
      imageProduct: [
        'assets/images/PetShop/BirdSeed.jpg',
      ],
      category: 'Food',
    ),
    Product(
      idProduct: 8,
      nameProduct: 'Aquarium Filter',
      description: 'Efficient filter for clean aquarium water.',
      price: 25.00,
      imageProduct: [
        'assets/images/PetShop/AquariumFilter.jpg',
      ],
      category: 'Equipment',
    ),
    Product(
      idProduct: 9,
      nameProduct: 'Dog Bed',
      description: 'Comfortable dog bed with removable cover.',
      price: 35.00,
      imageProduct: [
        'assets/images/PetShop/DogBed.jpg',
      ],
      category: 'Equipment',
    ),
    Product(
      idProduct: 10,
      nameProduct: 'Cat Toy',
      description: 'Interactive cat toy for active playtime.',
      price: 7.50,
      imageProduct: [
        'assets/images/PetShop/CatToy.jpg',
      ],
      category: 'GamePet',
    ),
    Product(
      idProduct: 11,
      nameProduct: 'Hamster Wheel',
      description: 'Silent spinner wheel for hamsters.',
      price: 15.00,
      imageProduct: [
        'assets/images/PetShop/HamsterWheel.jpg',
      ],
      category: 'GamePet',
    ),
    Product(
      idProduct: 12,
      nameProduct: 'Fish Food',
      description: 'Flake fish food for all freshwater fish.',
      price: 5.25,
      imageProduct: [
        'assets/images/PetShop/FishFood.jpg',
      ],
      category: 'Food',
    ),
    Product(
      idProduct: 13,
      nameProduct: 'Dog Shampoo',
      description: 'Gentle shampoo for dogs with sensitive skin.',
      price: 9.99,
      imageProduct: [
        'assets/images/PetShop/DogShampoo.jpg',
      ],
      category: 'Equipment',
    ),
    Product(
      idProduct: 14,
      nameProduct: 'Cat Scratcher',
      description: 'Durable cat scratcher with sisal rope.',
      price: 22.00,
      imageProduct: [
        'assets/images/PetShop/CatScratcher.jpg',
      ],
      category: 'Equipment',
    ),
    Product(
      idProduct: 15,
      nameProduct: 'Bird Perch',
      description: 'Natural wood perch for birds.',
      price: 6.99,
      imageProduct: [
        'assets/images/PetShop/BirdPerch.jpg',
      ],
      category: 'Cage',
    ),
  ];
}
