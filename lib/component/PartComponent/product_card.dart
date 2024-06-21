import 'package:flutter/material.dart';
import 'package:doca_project/dataset/datasetPetShop.dart';
import 'package:get/get.dart';
import 'package:doca_project/component/routeGlobal.dart';

class ProductCard extends StatelessWidget {
  final List<String> imageProduct;
  final String nameProduct;
  final double price;
  final Product product;

  ProductCard({
    required this.imageProduct,
    required this.nameProduct,
    required this.price,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.detailProduct, arguments: product);
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageProduct[0],
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameProduct,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$$price',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
