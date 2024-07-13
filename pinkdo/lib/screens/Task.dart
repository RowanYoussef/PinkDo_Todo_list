import 'package:flutter/material.dart';

class Task extends StatefulWidget {
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  static var priorities = ['High', 'Medium', 'Low'];
  String selectedValue = 'Low';
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[800]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details', style: TextStyle(color: Colors.white)),
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
          padding: EdgeInsets.only(top: 15, left: 10, right: 10),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink[300]!),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  items: priorities.map((String dropDownItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownItem,
                      child: Text(dropDownItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  dropdownColor: Colors.pink[50],
                  iconEnabledColor: Colors.pink[300],
                  icon: Icon(Icons.arrow_drop_down),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {},
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
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {},
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
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Colors.pink[300],
                          foregroundColor:  Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        style: ElevatedButton.styleFrom(
                         backgroundColor:  Colors.pink[300],
                          foregroundColor:  Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

