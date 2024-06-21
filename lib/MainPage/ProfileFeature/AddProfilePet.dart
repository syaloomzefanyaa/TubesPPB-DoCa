import 'package:doca_project/component/ColorGlobal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/component/PartComponent/header.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class addPetProfile extends StatefulWidget {
  @override
  _addPetProfileState createState() => _addPetProfileState();
}

class _addPetProfileState extends State<addPetProfile> {
  String? selectedGender;
  String? selectedPetType;
  String? selectedBreed;
  DateTime? selectedDate;
  File? _image;
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idUser = prefs.getInt('id_user') ?? 0;

    if (_nameController.text.isEmpty || selectedPetType == null || selectedBreed == null || selectedGender == null || _weightController.text.isEmpty || _colorController.text.isEmpty || _image == null) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    var request = http.MultipartRequest('POST', Uri.parse('http://${baseurl}addDataPet'));
    request.fields['id_user'] = idUser.toString();
    request.fields['name_pet'] = _nameController.text;
    request.fields['type_pet'] = selectedPetType!;
    request.fields['breed_pet'] = selectedBreed!;
    request.fields['sex'] = selectedGender!;
    request.fields['weight_pet'] = _weightController.text;
    request.fields['color_pet'] = _colorController.text;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath('image_pet', _image!.path));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pet profile added failed")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Pet profile added successfully")));
      Get.toNamed(RouteName.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: Header(title: 'Add Pet Profile'),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height / 7,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/images/pet_avatar.png') as ImageProvider,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera),
                      label: Text('Kamera'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo),
                      label: Text('Galeri'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20.0),
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name of pet*',
                          hintText: 'Name of pet',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Type of pet*',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedPetType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPetType = newValue;
                          });
                        },
                        items: <String>[
                          'Dog',
                          'Cat',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Breed of pet*',
                          border: OutlineInputBorder(),
                        ),
                        value: selectedBreed,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedBreed = newValue;
                          });
                        },
                        items: <String>[
                          'Golden Retriever',
                          'German Shepherd',
                          'Labrador Retriever',
                          'Bulldog',
                          'Beagle',
                          'Poodle',
                          'Boxer',
                          'Siberian Husky',
                          'Dachshund',
                          'Chihuahua'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gender*',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Male',
                                groupValue: selectedGender,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                              Text('Male'),
                              Radio<String>(
                                value: 'Female',
                                groupValue: selectedGender,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                              Text('Female'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _weightController,
                        decoration: InputDecoration(
                          labelText: 'Enter pet Weight*',
                          hintText: 'Enter pet Weight',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _colorController,
                        decoration: InputDecoration(
                          labelText: 'Enter Pet Color*',
                          hintText: 'Enter Pet Color',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Next'),
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

  // Fungsi untuk memilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }
}
