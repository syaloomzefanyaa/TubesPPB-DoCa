import 'package:flutter/material.dart';
import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/component/ColorGlobal.dart';

class Navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.6), // Mengatur warna item yang tidak dipilih
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => homePage));
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => listPet));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => profile));
            break;
        }
      },
    );
  }
}
