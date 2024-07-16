import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:pinkdo/icons.dart';

class TaskLogic {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  DateTime? selectedDate;
  IconData? selectedIcon;
  Sqldb sqldb = Sqldb();

  void saveTask(context, int icon) async {
    try {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      String deadline = deadlineController.text;

      if (title.isNotEmpty) {
        int response = await sqldb.insertData(
            "INSERT INTO tasks (task, completed, Description, deadline, icon) VALUES ('$title', 0, '$description', '$deadline',$icon)");
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

  Future <void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      deadlineController.text = DateFormat('yyyy-MM-dd').format(selectedDate!);
    }
  }

  Future<void> showIconPicker(BuildContext context) async {
    icons i = icons();
    final icon = i.getIcons();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Icon'),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: icon.length,
              itemBuilder: (context, index) {
                return IconButton(
                  icon:
                      Icon(icon[index], color: Theme.of(context).primaryColor),
                  onPressed: () {
                    selectedIcon = icon[index];
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  IconData? getSelectedIcon() {
    return selectedIcon;
  }

  DateTime? getSelectedDate() {
    return selectedDate;
  }
}
