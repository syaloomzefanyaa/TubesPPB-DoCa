import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doca_project/MainPage/HomePage.dart';
import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/MainPage/TaskUserFeature/ListTaskUser.dart';

class FormEditTaskPage extends StatefulWidget {
  final int taskId;
  final String initialCategory;
  final String initialDescription;
  final DateTime initialDate;
  final Function(TaskUser) onUpdate;
  final int idPet;
  final int idUser;

  FormEditTaskPage({
    required this.taskId,
    required this.initialCategory,
    required this.initialDescription,
    required this.initialDate,
    required this.onUpdate,
    required this.idPet,
    required this.idUser
  });

  @override
  _FormEditTaskPageState createState() => _FormEditTaskPageState();
}

class _FormEditTaskPageState extends State<FormEditTaskPage> {
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.initialCategory);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _categoryController.text,
              items: ['Hygiene', 'Food', 'Activities', 'Medical']
                  .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ))
                  .toList(),
              onChanged: (String? value) {
                setState(() {
                  _categoryController.text = value ?? '';
                });
              },
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
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
            TextButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8.0),
                  Text(_selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Select Date'),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateTask,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask() async {
    final response = await http.put(
      Uri.parse('${baseurl}updateTaskUser/${widget.taskId}'),
      body: {
        'id_user': widget.idUser.toString(),
        'id_pet': widget.idPet.toString(),
        'category': _categoryController.text,
        'date': _selectedDate?.toString() ?? '',
        'description': _descriptionController.text,
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Task updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      widget.onUpdate(TaskUser(
        idTask: widget.taskId,
        idUser: 0, // Update with appropriate value
        idPet: 0, // Update with appropriate value
        category: _categoryController.text,
        date: _selectedDate ?? DateTime.now(),
        description: _descriptionController.text,
        isDone: 0, // Update with appropriate value
      ));

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to update task",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
