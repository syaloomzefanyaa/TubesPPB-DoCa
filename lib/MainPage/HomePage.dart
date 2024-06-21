import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/component/ColorGlobal.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/component/PartComponent/headerUser.dart';
import 'package:doca_project/MainPage/TaskUserFeature/ListTaskUser.dart';

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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';
  String _profileImageUrl = '';
  List<Pet> pets = [];
  List<TaskUser> tasks = [];
  int _currentPetIndex = 0;
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    _loadLastLoggedInUser();
    _checkLoginStatus();
  }

  Future<void> _loadLastLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? '';
      _profileImageUrl = prefs.getString('image') ?? 'https://example.com/profile.jpg';
      _userId = prefs.getInt('id_user') ?? 0;
    });
    if (_userId != 0) {
      await _fetchPets();
    }
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int isLogin = prefs.getInt('isLogin') ?? 0;
    if (isLogin == 2) {
      Fluttertoast.showToast(
        msg: "Sesi anda telah habis",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      Navigator.pushReplacementNamed(context, RouteName.login);
    } else if (isLogin == 1) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('username') ?? '';
      _profileImageUrl = prefs.getString('image') ?? 'https://example.com/profile.jpg';
    });
  }

  Future<void> _fetchPets() async {
    final response = await http.get(Uri.parse('${baseurl}getDataPetByUserID/$_userId'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        pets = data.map((item) => Pet.fromJson(item)).toList();
      });
      if (pets.isNotEmpty) {
        await _fetchTasks(pets[_currentPetIndex].idPet);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to load pets",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _fetchTasks(int idPet) async {
    final response = await http.get(Uri.parse('${baseurl}getDataTaskByPetID/$idPet'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        tasks = data.map((item) => TaskUser.fromJson(item)).toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: "Failed to load tasks",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _nextPet() {
    setState(() {
      _currentPetIndex = (_currentPetIndex + 1) % pets.length;
      _fetchTasks(pets[_currentPetIndex].idPet);
    });
  }

  void _navigateToTaskUser(int petIndex) {
    int idPet = pets[petIndex].idPet;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskUserList(
          idPet: idPet,
          idUser: _userId,
        ),
      ),
    );
  }

  void _showConfirmationDialog(TaskUser task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Apakah Anda sudah melakukannya?'),
          actions: <Widget>[
            TextButton(
              child: Text('Belum'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya, sudah'),
              onPressed: () {
                _markTaskAsDone(task);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _markTaskAsDone(TaskUser task) async {
    final response = await http.put(Uri.parse('${baseurl}tasks/${task.idTask}/done'));

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Tugas telah ditandai sebagai selesai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await _fetchTasks(pets[_currentPetIndex].idPet);

    } else {
      Fluttertoast.showToast(
        msg: "Gagal menandai tugas sebagai selesai",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    Pet currentPet = pets.isNotEmpty
        ? pets[_currentPetIndex]
        : Pet(idPet: 0, idUser: 0, namePet: '', typePet: '', breedPet: '', sex: '', weightPet: 0, colorPet: '', imagePet: '');

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: HeaderUser(
          userName: _userName,
          profileImageUrl: _profileImageUrl,
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 50.0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                  topRight: Radius.circular(80),
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0),
                if (pets.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(currentPet.imagePet),
                        ),
                        title: Text(currentPet.namePet),
                        subtitle: Text('${currentPet.typePet} | ${currentPet.breedPet}\n${currentPet.sex} | ${currentPet.weightPet} kg'),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: _nextPet, // Call the _nextPet function here
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeatureButton(
                        icon: Icons.pets,
                        label: 'Petcare',
                        onTap: () {
                          Get.toNamed(RouteName.listPet);
                        },
                      ),
                      _buildFeatureButton(
                        icon: Icons.store,
                        label: 'Petshop',
                        onTap: () {
                          Get.toNamed(RouteName.petShop);
                        },
                      ),
                      _buildFeatureButton(
                        icon: Icons.add_box,
                        label: 'PetClinic',
                        onTap: () {
                          Get.toNamed(RouteName.petClinic);
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Task',
                              style: TextStyle(
                                fontSize: 21,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => _navigateToTaskUser(_currentPetIndex),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.teksDescription,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(3.0),
                        height: 250.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: AppColors.descriptionColor,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: tasks.map((task) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(task.category),
                                    subtitle: Text(task.description),
                                    trailing: Checkbox(
                                      value: task.isDone == 1, // Set nilai checkbox
                                      onChanged: (newValue) {
                                        _showConfirmationDialog(task);
                                      },
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(),
    );
  }

  Widget _buildFeatureButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          IconButton(
            icon: Icon(icon, size: 50),
            onPressed: onTap,
          ),
          Text(label),
        ],
      ),
    );
  }
}
