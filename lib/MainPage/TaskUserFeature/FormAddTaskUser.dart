import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:doca_project/component/PartComponent/header.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/component/ColorGlobal.dart';
import 'package:intl/intl.dart';
import 'package:doca_project/MainPage/HomePage.dart';
import 'package:doca_project/component/routeGlobal.dart';

class FormAddTaskPage extends StatefulWidget {
  final int idPet;
  final int idUser;

  FormAddTaskPage({required this.idPet, required this.idUser});

  @override
  _FormAddTaskPageState createState() => _FormAddTaskPageState();
}

class _FormAddTaskPageState extends State<FormAddTaskPage> {
  final List<String> categories = ['Hygiene', 'Food', 'Activities', 'Medical'];
  String? selectedCategory;
  bool isDropdownExpanded = false;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: Header(title: 'Add Task'),
      body: Stack(
        children: [
          Positioned(
            top: 20.0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDropdownExpanded = !isDropdownExpanded;
                        });
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          selectedCategory ?? 'Select Category',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    if (isDropdownExpanded)
                      Container(
                        color: Colors.grey[200],
                        child: Column(
                          children: categories.map((String category) {
                            return ListTile(
                              title: Text(category),
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                  isDropdownExpanded = false;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    SizedBox(height: isDropdownExpanded ? 16.0 : 0),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                          setState(() {
                            _dateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _submitTaskUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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

  void _submitTaskUser() async {
    String date = _dateController.text;
    String description = _descriptionController.text;

    print('Category: $selectedCategory');
    print('Date: $date');
    print('Description: $description');

    final response = await http.post(
      Uri.parse('${baseurl}addTaskUser'),
      body: {
        'id_user': widget.idUser.toString(),
        'id_pet': widget.idPet.toString(),
        'category': selectedCategory ?? '',
        'date': date,
        'description': description,
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Proses gagal",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Kegiatan berhasil ditambah",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    }
  }
}
