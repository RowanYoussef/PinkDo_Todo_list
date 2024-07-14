import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';

class Wish extends StatefulWidget {
  @override
  State<Wish> createState() => _WishState();
}

class _WishState extends State<Wish> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Sqldb sqldb = Sqldb();

  void saveWish() async {
    try {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();;

      if (title.isNotEmpty) {
        int response = await sqldb.insertData(
          "INSERT INTO wishes (wish, completed, description) VALUES ('$title', 0, '$description')"
        );
        if (response > 0) 
            Navigator.pop(context, true); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a title for the wish.'),
          backgroundColor: Colors.pink[200],
        ));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.pink[200],
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
        title: Text('Wish Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pink[300],
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
            colors: [Colors.pink[50]!, Colors.pink[100]!],
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
                    borderSide: BorderSide(color: Colors.pink[300]!),
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
                    borderSide: BorderSide(color: Colors.pink[300]!),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      saveWish();
                    },
                    child: Text(
                      'Save',
                      textScaleFactor: 1.5,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.pink[300],
                      foregroundColor:  Colors.white,
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
                    },
                    child: Text(
                      'Delete',
                      textScaleFactor: 1.5,
                    ),
                    style: ElevatedButton.styleFrom(
                    backgroundColor:  Colors.pink[300],
                      foregroundColor:  Colors.white,
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