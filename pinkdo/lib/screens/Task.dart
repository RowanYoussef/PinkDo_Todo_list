import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:pinkdo/Themes/theme.dart';
import 'package:pinkdo/Themes/themeNotifier.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:provider/provider.dart';

class Task extends StatefulWidget {
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  DateTime? selectedDate;
  Sqldb sqldb = Sqldb();

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        deadlineController.text =
            DateFormat('yyyy-MM-dd').format(selectedDate!);
      });
    }
  }

  void saveTask() async {
    try {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();

      String? deadline = deadlineController.text;

      if (title.isNotEmpty) {
        int response = await sqldb.insertData(
            "INSERT INTO tasks (task, completed, description, deadline) VALUES ('$title', 0, '$description', '$deadline')");
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

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(color: Colors.grey[800]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [ ThemeData().colorScheme.surface,Theme.of(context).colorScheme.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              TextField(
                controller: titleController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor!),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: deadlineController,
                style: textStyle,
                decoration: InputDecoration(
                  labelText: 'Deadline',
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () {
                      selectDate(context);
                    },
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      saveTask();
                    },
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add your delete logic here if needed
                    },
                    child: Text(
                      'Delete',
                      textScaleFactor: 1.5,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
