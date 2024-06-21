import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doca_project/MainPage/ProfileFeature/ProfilePage.dart';
import 'package:doca_project/component/ColorGlobal.dart';
import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/component/PartComponent/header.dart';
import 'package:doca_project/MainPage/ProfileFeature/editProfilePet.dart';

class PetProfilePage extends StatelessWidget {
  final Pet pet;
  final int idUser;

  const PetProfilePage({Key? key, required this.pet, required this.idUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: Header(title: 'Pet Profile'),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height / 35,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: pet != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(pet.imagePet),
                          radius: 30.0,
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              pet.namePet,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              pet.typePet,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 10.0, left: 10.0),
                      decoration: BoxDecoration(
                        color: AppColors.descriptionColor,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Category: ${pet.typePet}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.teksDescription,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Description: ${pet.breedPet}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.teksDescription,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sex: ${pet.sex}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.teksDescription,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Weight: ${pet.weightPet} kg',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.teksDescription,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Color: ${pet.colorPet}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.teksDescription,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  Spacer(), // This pushes the button to the bottom
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => editPetProfile(
                                idPet: pet.idPet,
                                idUser: idUser,
                              ),
                            ),
                          );
                        },
                        child: Text('Edit Profile Pet', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Background color
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0), // Space between button and bottom
                ],
              )
                  : Center(
                child: Text('Pet not found'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(),
    );
  }
}
