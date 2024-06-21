import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doca_project/component/routeGlobal.dart';

class DeleteTaskModal {
  static Future<void> showDeleteConfirmationDialog(BuildContext context, int idTask, VoidCallback onDeleteSuccess) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation delete'),
          content: Text('Are you sure delete the task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await http.delete(Uri.parse('${baseurl}deleteTaskUser/$idTask'));
                Navigator.of(context).pop();

                if (response.statusCode == 200) {
                  Fluttertoast.showToast(
                    msg: "The task is completely deleted",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  onDeleteSuccess();
                } else {
                  Fluttertoast.showToast(
                    msg: "Failed delete task",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text('Yes, Sure'),
            ),
          ],
        );
      },
    );
  }
}
