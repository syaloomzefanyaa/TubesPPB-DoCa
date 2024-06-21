import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doca_project/component/routeGlobal.dart';
import 'package:get/get.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';

class editPetProfile extends StatefulWidget {
  final int idPet;
  final int idUser;

  const editPetProfile({Key? key, required this.idPet, required this.idUser}) : super(key: key);

  @override
  _editPetProfileState createState() => _editPetProfileState();
}

class _editPetProfileState extends State<editPetProfile> {
  String? namePet;
  String? selectedPetType;
  String? selectedBreed;
  String? selectedGender;
  double? weightPet;
  String? colorPet;
  String? imagePet;
  File? _image;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedGender = null;
    _fetchPetData();
  }

  Future<void> _fetchPetData() async {
    final response = await http.get(Uri.parse('${baseurl}getDataPet/${widget.idPet}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        namePet = data['name_pet'];
        selectedPetType = data['type_pet'];
        selectedBreed = data['breed_pet'];
        selectedGender = data['sex'];
        weightPet = data['weight_pet'].toDouble();
        colorPet = data['color_pet'];
        imagePet = data['image_pet'];
        _nameController.text = namePet ?? '';
        _weightController.text = weightPet?.toString() ?? '';
        _colorController.text = colorPet ?? '';
      });
    } else {
      print('Failed to load pet data');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        imagePet = _image!.path;
      });
    }
  }

  Future<void> updatePetData() async {
    print("ID User: ${widget.idUser}");
    print("Name of pet: ${_nameController.text}");
    print("Type of pet: $selectedPetType");
    print("Breed of pet: $selectedBreed");
    print("Gender: $selectedGender");
    print("Weight of pet: ${_weightController.text}");
    print("Color of pet: ${_colorController.text}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idUser = prefs.getInt('id_user') ?? 0;

    var request = http.MultipartRequest('PUT', Uri.parse('${baseurl}updatePetData/${widget.idPet}'));
    request.fields['id_user'] = idUser.toString();
    request.fields['name_pet'] = _nameController.text;
    request.fields['type_pet'] = selectedPetType!;
    request.fields['breed_pet'] = selectedBreed!;
    request.fields['sex'] = selectedGender!;
    request.fields['weight_pet'] = _weightController.text;
    request.fields['color_pet'] = _colorController.text;

    if (_image != null) {
      var fileName = _image!.path.split('/').last;
      print("New Image: $fileName");
      request.files.add(await http.MultipartFile.fromPath('image_pet', _image!.path));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        print("Pet has Successfully Updated");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Pet has Successfully Updated'),
          backgroundColor: Colors.green,
        ));
        Get.toNamed(RouteName.home);
      } else {
        print("Failed to update pet data");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update pet data'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print("Error updating pet data: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error updating pet data'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA500),
      appBar: AppBar(
        title: Text('Edit Pet Profile'),
        backgroundColor: Color(0xFFFFA500),
      ),
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
                      : imagePet != null
                      ? NetworkImage(imagePet!)
                      : AssetImage('assets/images/pet_avatar.png') as ImageProvider<Object>?,
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
                          labelText: 'Weight of pet*',
                          hintText: 'Weight of pet',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _colorController,
                        decoration: InputDecoration(
                          labelText: 'Color of pet*',
                          hintText: 'Color of pet',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: updatePetData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Update Pet Profile',
                          style: TextStyle(fontSize: 18),
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
}
