// task_user_dataset.dart
class TaskUser {
  final int idTask;
  final int idUser;
  final String category;
  final DateTime date;
  final String description;

  TaskUser({
    required this.idTask,
    required this.idUser,
    required this.category,
    required this.date,
    required this.description,
  });
}

List<TaskUser> generateTaskUserList() {
  return [
    TaskUser(
      idTask: 1,
      idUser: 1,
      category: 'Hygiene',
      date: DateTime(2024, 6, 14, 8, 0),
      description: 'Take a bath',
    ),
    TaskUser(
      idTask: 2,
      idUser: 1,
      category: 'Food',
      date: DateTime(2024, 6, 17, 8, 0),
      description: 'Snack time',
    ),
    TaskUser(
      idTask: 3,
      idUser: 1,
      category: 'Activities',
      date: DateTime(2024, 6, 15, 8, 0),
      description: 'Walking',
    ),
    TaskUser(
      idTask: 4,
      idUser: 1,
      category: 'Hygiene',
      date: DateTime(2024, 6, 14, 9, 0),
      description: 'Brush teeth',
    ),
    TaskUser(
      idTask: 5,
      idUser: 1,
      category: 'Food',
      date: DateTime(2024, 6, 17, 9, 0),
      description: 'Lunch',
    ),
    TaskUser(
      idTask: 6,
      idUser: 1,
      category: 'Activities',
      date: DateTime(2024, 6, 15, 9, 0),
      description: 'Yoga',
    ),
    TaskUser(
      idTask: 7,
      idUser: 1,
      category: 'Hygiene',
      date: DateTime(2024, 6, 14, 10, 0),
      description: 'Shower',
    ),
    TaskUser(
      idTask: 8,
      idUser: 1,
      category: 'Food',
      date: DateTime(2024, 6, 17, 10, 0),
      description: 'Dinner',
    ),
    TaskUser(
      idTask: 9,
      idUser: 1,
      category: 'Activities',
      date: DateTime(2024, 6, 15, 10, 0),
      description: 'Running',
    ),
    TaskUser(
      idTask: 10,
      idUser: 1,
      category: 'Hygiene',
      date: DateTime(2024, 6, 14, 11, 0),
      description: 'Wash face',
    ),
    TaskUser(
      idTask: 11,
      idUser: 1,
      category: 'Food',
      date: DateTime(2024, 6, 17, 11, 0),
      description: 'Breakfast',
    ),
    TaskUser(
      idTask: 12,
      idUser: 1,
      category: 'Activities',
      date: DateTime(2024, 6, 15, 11, 0),
      description: 'Gym',
    ),
    TaskUser(
      idTask: 13,
      idUser: 1,
      category: 'Hygiene',
      date: DateTime(2024, 6, 16, 8, 0),
      description: 'Manicure',
    ),
    TaskUser(
      idTask: 14,
      idUser: 1,
      category: 'Food',
      date: DateTime(2024, 6, 16, 9, 0),
      description: 'Brunch',
    ),
    TaskUser(
      idTask: 15,
      idUser: 1,
      category: 'Activities',
      date: DateTime(2024, 6, 16, 10, 0),
      description: 'Cycling',
    ),
    TaskUser(
      idTask: 16,
      idUser: 1,
      category: 'Hygiene',
      date: DateTime(2024, 6, 16, 11, 0),
      description: 'Pedicure',
    ),
  ];
}
