import 'dart:io';
import 'package:doca_project/CompleteDataPet/CompleteDataPet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CompleteImage extends StatefulWidget {
  final int idUser; // Terima id_user dari RegisterPage

  CompleteImage({required this.idUser});

  @override
  _CompleteImageState createState() => _CompleteImageState();
}

class _CompleteImageState extends State<CompleteImage> {
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _navigateToCompleteDataPet() {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompleteDataPet(
            imageFile: _imageFile,
            idUser: widget.idUser, // Teruskan id_user ke CompleteDataPet, dengan membawa id_user yang diambil dari yang regiter
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFA500),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome To DoCa',
                    style: TextStyle(fontSize: 37, fontWeight: FontWeight.bold, color: Color(0xFF41484D)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Complete your pet Profile',
                    style: TextStyle(fontSize: 27, color: Color(0xFF41484D)),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.only(top: 30.0, right: 30.0, left: 30.0),
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
                  Container(
                    width: 270,
                    height: 270,
                    color: Colors.grey,
                    child: _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      width: 270,
                      height: 270,
                      fit: BoxFit.cover,
                    )
                        : Center(child: Text('No image selected.')),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/iconFile.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text('Galery'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        child: ElevatedButton(
                          onPressed: () => _pickImage(ImageSource.camera),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/iconCamera.png',
                                width: 24,
                                height: 24,
                              ),
                              SizedBox(width: 8),
                              Text('Camera'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _navigateToCompleteDataPet,
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
    );
  }
}
