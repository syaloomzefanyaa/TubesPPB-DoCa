import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/component/ColorGlobal.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/MainPage/ProfileFeature/deletePetModal.dart';
import 'package:doca_project/MainPage/ProfileFeature/PetProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:doca_project/Auth/LoginPage.dart';
import 'dart:convert';
import 'package:doca_project/MainPage/ProfileFeature/EditProfileUser.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isPetListVisible = false;
  List<Pet> petList = [];
  String _username = '';
  String _email = '';
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchPetList();
  }

  Future<void> _fetchPetList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idUser = prefs.getInt('id_user') ?? 0;
    final url = '${baseurl}getDataPetByUserID/$idUser';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          petList = data.map((json) => Pet.fromJson(json)).toList();
        });
      } else {
        _showErrorToast("Failed to load pet list");
      }
    } catch (e) {
      _showErrorToast("An error occurred while fetching pet list");
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idUser = prefs.getInt('id_user') ?? 0;

    final url = '${baseurl}logout';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'id_user': idUser.toString()},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['message'] == 'Logout berhasil') {
        await prefs.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );

        Fluttertoast.showToast(
          msg: "You have successfully logged out",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
        );
      } else {
        _showErrorToast("Logout failed, please try again");
      }
    } else {
      _showErrorToast("Logout failed, please try again");
    }
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Nama Pengguna';
      _email = prefs.getString('email') ?? 'user@example.com';
      _profileImageUrl = prefs.getString('image') ?? 'https://example.com/profile.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: Image.asset(
                  'assets/images/Logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditUserProfile()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(_profileImageUrl),
                            radius: 30.0,
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _username,
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                              Text(_email),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPetListVisible = !_isPetListVisible;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (_isPetListVisible)
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteName.addProfilePet);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                ),
                              SizedBox(width: 8.0),
                              Text(
                                'List Pet',
                                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Icon(
                            _isPetListVisible ? Icons.expand_less : Icons.expand_more,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isPetListVisible)
                    Expanded(
                      child: SizedBox(
                        height: 300.0,
                        child: SingleChildScrollView(
                          child: Column(
                            children: petList.map((pet) {
                              return _buildPetProfile(context, pet);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _logout,
                          child: Text('Logout', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            minimumSize: Size(double.infinity, 48),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            // Aksi ketika teks "contact us" ditekan
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Need help? ',
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Contact us',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget _buildPetProfile(BuildContext context, Pet pet) {
    return GestureDetector(
      onTap: () {
        // Aksi ketika kontainer hewan peliharaan ditekan
      },
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(pet.imagePet),
            radius: 30.0,
          ),
          title: Text(
            pet.namePet,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(pet.typePet),
          trailing: PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
    PopupMenuItem<String>(
      value: 'see_pet',
      child: Text('See Pet'),
    ),
    PopupMenuItem<String>(
    value: 'delete_pet',
    child: Text('Delete Pet'),
    ),
    ],
    onSelected: (String value) {
    if (value == 'see_pet') {
    if (pet != null) {
    Get.to(() => PetProfilePage(pet: pet, idUser: pet.idUser));
    }
    } else if (value == 'delete_pet') {
    showDialog(
    context: context,
    builder: (BuildContext context) {
    return deletePetModal(pet: pet);
    },
    ).then((value) {
    if (value == true) {
    setState(() {
    petList.remove(pet);
    });}
    });
    }
    },
    ),
    ),
    );
    }
  }

  class Pet {
  final int idPet;
  final int idUser;
  final String namePet;
  final String typePet;
  final String breedPet;
  final String sex;
  final double weightPet;
  final String colorPet;
  final String imagePet;

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

  factory Pet.fromJson(Map<String, dynamic> json) {
  return Pet(
  idPet: json['id_pet'],
  idUser: json['id_user'],
  namePet: json['name_pet'],
  typePet: json['type_pet'],
  breedPet: json['breed_pet'],
  sex: json['sex'],
  weightPet: json['weight_pet'].toDouble(),
  colorPet: json['color_pet'],
  imagePet: json['image_pet'],
  );
  }
  }
