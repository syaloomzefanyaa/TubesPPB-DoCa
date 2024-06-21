import 'dart:convert';
import 'package:doca_project/component/PartComponent/header.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:doca_project/component/ColorGlobal.dart';
import 'package:doca_project/MainPage/HomePage.dart';
import 'package:doca_project/MainPage/TaskUserFeature/formEditTaskUser.dart';
import 'package:doca_project/MainPage/TaskUserFeature/deleteTaskModal.dart';
import 'package:doca_project/component/PartComponent/headerWithFilterDate.dart';
import 'package:doca_project/component/PartComponent/navbar.dart';
import 'package:doca_project/MainPage/TaskUserFeature/FormAddTaskUser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doca_project/component/routeGlobal.dart';

class TaskUser {
  final int idTask;
  final int idUser;
  final int idPet;
  final String category;
  final DateTime date;
  final String description;
  final int isDone;

  TaskUser({
    required this.idTask,
    required this.idUser,
    required this.idPet,
    required this.category,
    required this.date,
    required this.description,
    required this.isDone,
  });

  factory TaskUser.fromJson(Map<String, dynamic> json) {
    return TaskUser(
      idTask: json['id_task'],
      idUser: json['id_user'],
      idPet: json['id_pet'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      isDone: json['is_done'],
    );
  }
}

class TaskUserList extends StatefulWidget {
  final int idPet;
  final int idUser;

  TaskUserList({required this.idPet, required this.idUser});

  @override
  _TaskUserListState createState() => _TaskUserListState();
}

class _TaskUserListState extends State<TaskUserList> {
  late List<TaskUser> taskUserList = [];
  DateTime? selectedDate;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTaskUserList();
  }

  Future<void> _fetchTaskUserList() async {
    final response = await http.get(Uri.parse('${baseurl}getDataTaskByPetID/${widget.idPet}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        taskUserList = data.map((json) => TaskUser.fromJson(json)).toList();
        _loading = false;
      });
    } else {
      throw Exception('Failed to load tasks');
    }

    // Tunggu 3 detik setelah data diambil
    await Future.delayed(Duration(seconds: 3));

    // Setelah menunggu 3 detik, periksa apakah taskUserList masih kosong
    if (taskUserList.isEmpty) {
      setState(() {
        _loading = false;
      });
    }
  }

  void _deleteTask(int idTask) {
    DeleteTaskModal.showDeleteConfirmationDialog(context, idTask, () {
      setState(() {
        taskUserList.removeWhere((task) => task.idTask == idTask);
      });
    });
  }

  void _editTask(TaskUser task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEditTaskPage(
          idPet: widget.idPet,
          idUser: widget.idUser,
          taskId: task.idTask,
          initialCategory: task.category,
          initialDescription: task.description,
          initialDate: task.date,
          onUpdate: (updatedTask) {
            setState(() {
              int index = taskUserList.indexWhere((element) => element.idTask == updatedTask.idTask);
              if (index != -1) {
                taskUserList[index] = updatedTask;
              }
            });
          },
        ),
      ),
    );
  }

  List<Widget> _buildTaskColumn(DateTime date) {
    List<Widget> columnItems = [];

    List<TaskUser> tasksInColumn = taskUserList.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();

    columnItems.add(
      Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.descriptionColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: tasksInColumn.map((task) {
            return Column(
              children: [
                ListTile(
                  leading: Checkbox(
                    value: task.isDone == 1, // Set nilai checkbox
                    onChanged: (newValue) {
                      _showConfirmationDialog(task);
                    },
                  ),
                  title: Text(task.category),
                  subtitle: Text(task.description),
                  trailing: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (BuildContext context) {
                      return <PopupMenuEntry>[
                        PopupMenuItem(
                          child: Text('Edit Task'),
                          onTap: () {
                            _editTask(task);
                          },
                        ),
                        PopupMenuItem(
                          child: Text('Hapus Task'),
                          onTap: () {
                            Future.delayed(
                              const Duration(seconds: 0),
                                  () => _deleteTask(task.idTask),
                            );
                          },
                        ),
                      ];
                    },
                  ),
                ),
                if (tasksInColumn.indexOf(task) != tasksInColumn.length - 1) Divider(),
              ],
            );
          }).toList(),
        ),
      ),
    );

    return columnItems;
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
      await _fetchTaskUserList();
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

  List<DateTime> _getUniqueDates() {
    List<DateTime> uniqueDates = taskUserList.map((task) => DateTime(task.date.year, task.date.month, task.date.day)).toSet().toList();

    uniqueDates.sort((a, b) => b.compareTo(a));

    return uniqueDates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'List Task'),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : taskUserList.isEmpty
          ? Center(child: Text('You don\'t have any tasks',))
          : ListView(
        children: _getUniqueDates().map((date) {
          return Container(
            padding: EdgeInsets.only(bottom: 10.0, right: 15.0, left: 15.0),
            margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text(
                    _formatDate(date),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                ..._buildTaskColumn(date),
              ],
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Navbar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormAddTaskPage(
                idPet: widget.idPet,
                idUser: widget.idUser,
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
