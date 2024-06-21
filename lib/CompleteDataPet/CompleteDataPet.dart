import 'package:doca_project/MainPage/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doca_project/component/routeGlobal.dart';
import 'dart:convert';
import 'dart:io';

class CompleteDataPet extends StatefulWidget {
  final File? imageFile;
  final int idUser;

  CompleteDataPet({this.imageFile, required this.idUser});

  @override
  _CompleteDataPetState createState() => _CompleteDataPetState();
}

class _CompleteDataPetState extends State<CompleteDataPet> {
  String? selectedPetType;
  String? selectedBreed;
  String? selectedGender;
  DateTime? selectedDate;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController colorController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _submitData() async {
    final uri = Uri.parse('${baseurl}addDataPet');

    var request = http.MultipartRequest('POST', uri)
      ..fields['id_user'] = widget.idUser.toString()
      ..fields['name_pet'] = nameController.text
      ..fields['type_pet'] = selectedPetType!
      ..fields['breed_pet'] = selectedBreed!
      ..fields['sex'] = selectedGender!
      ..fields['date_of_birth'] = selectedDate.toString()
      ..fields['weight_pet'] = weightController.text
      ..fields['color_pet'] = colorController.text;

    if (widget.imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image_pet',
        widget.imageFile!.path,
      ));
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Failed to add profile');
    } else {
      print('Profile added successfully');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => loginPage),
      );
    }

    // Print all user input to console
    print('ID User: ${widget.idUser}');
    print('Name of pet: ${nameController.text}');
    print('Type of pet: $selectedPetType');
    print('Breed of pet: $selectedBreed');
    print('Gender: $selectedGender');
    print('Date of Birth: $selectedDate');
    print('Weight of pet: ${weightController.text}');
    print('Color of pet: ${colorController.text}');
    if (widget.imageFile != null) {
      print('Image file path: ${widget.imageFile!.path}');
    } else {
      print('No image file selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA500),
      appBar: AppBar(
        title: Text(
          'Pet Biography',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFFA500),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 35.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name of pet*',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: 'Name of pet',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: DropdownButtonFormField<String>(
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
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: DropdownButtonFormField<String>(
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
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gender*',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Date of Birth*',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: Text(
                                    selectedDate != null
                                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                        : 'Select Date',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: weightController,
                          decoration: InputDecoration(
                            labelText: 'Weight of pet (kg)*',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'Weight of pet',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: colorController,
                          decoration: InputDecoration(
                            labelText: 'Color of pet*',
                            labelStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'Color of pet',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text('Submit'),
                        ),
                      ],
                    ),
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
