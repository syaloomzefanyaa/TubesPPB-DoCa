import 'package:flutter/material.dart';
import 'package:doca_project/component/PartComponent/header.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/component/ColorGlobal.dart';
import 'package:doca_project/dataset/datasetPetShop.dart';
import 'package:doca_project/component/PartComponent/product_card.dart';
import 'package:get/get.dart';
import 'package:doca_project/component/routeGlobal.dart';

class PetShopPage extends StatefulWidget {
  @override
  _PetShopPageState createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  late List<Product> products;
  String searchQuery = '';
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    products = generateProductList();
  }

  List<Product> getFilteredProducts() {
    // Filter based on search and category
    return products.where((product) {
      final nameMatches =
      product.nameProduct.toLowerCase().contains(searchQuery.toLowerCase());
      final categoryMatches = selectedCategory.isEmpty ||
          product.category == selectedCategory;
      return nameMatches && categoryMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: Header(title: 'Product'),
      body: Stack(
        children: [
          Positioned(
            top: 10.0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: AppColors.background2Color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30.0,
            left: 20.0,
            right: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    suffixIcon: Icon(Icons.search),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 50.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterButton('Food'),
                      _buildFilterButton('Cage'),
                      _buildFilterButton('Equipment'),
                      _buildFilterButton('GamePet'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 90.0 + 66.0, // Adjust this value as needed to account for the height of search box, buttons, and padding
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0), // Mengubah padding menjadi 8.0
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: getFilteredProducts().length,
                      itemBuilder: (context, index) {
                        final filteredProducts = getFilteredProducts();
                        return ProductCard(
                          imageProduct: filteredProducts[index].imageProduct,
                          nameProduct: filteredProducts[index].nameProduct,
                          price: filteredProducts[index].price,
                          product: filteredProducts[index],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget _buildFilterButton(String category) {
    bool isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RouteName.home,
      getPages: getPages,
      home: PetShopPage(),
    );
  }
}
