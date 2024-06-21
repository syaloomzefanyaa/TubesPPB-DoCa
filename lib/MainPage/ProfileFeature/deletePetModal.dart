import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doca_project/component/routeGlobal.dart';
import 'package:doca_project/MainPage/ProfileFeature/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class deletePetModal extends StatelessWidget {
  final Pet pet;

  const deletePetModal({Key? key, required this.pet}) : super(key: key);

  Future<void> _deletePet(BuildContext context) async {
    final url = '${baseurl}deleteDataPet/${pet.idPet}';

    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Pet profile deleted successfully"),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).pop(true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to delete pet profile"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred while deleting pet profile"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Pet'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Are you sure you want to delete this pet?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deletePet(context);
          },
          child: Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}
