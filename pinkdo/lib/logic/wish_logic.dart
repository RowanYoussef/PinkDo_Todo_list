import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';
class WishLogic {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Sqldb sqldb = Sqldb();

  void saveWish(context) async {
    try {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      ;

      if (title.isNotEmpty) {
        int response = await sqldb.insertData(
            "INSERT INTO wishes (wish, completed, Description) VALUES ('$title', 0, '$description')");
        if (response > 0) Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a title for the wish.'),
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