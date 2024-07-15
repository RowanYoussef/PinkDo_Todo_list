import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinkdo/database/sql.dart';

class TaskLogic {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Sqldb sqldb = Sqldb();

  void saveTask(context,String? deadline) async {
    try {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      if (title.isNotEmpty) {
        int response = await sqldb.insertData(
            "INSERT INTO tasks (task, completed, Description, deadline) VALUES ('$title', 0, '$description', '$deadline')");
        if (response > 0) {
          Navigator.pop(context, true);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a title for the task.'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    }
  }
}