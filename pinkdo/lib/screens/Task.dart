import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Task extends StatefulWidget {
  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  static var priorities = ['High', 'medium', 'low'];
  String selectedValue = 'low';
  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;
    return Scaffold(
      appBar: AppBar(
        title: Text('Task details'),
        backgroundColor: Colors.pink[200],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15, left: 10, right: 10),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                  items: priorities.map((String dropDownitem) {
                    return DropdownMenuItem<String>(
                        value: dropDownitem,
                        child: Text(
                          dropDownitem,
                        ));
                  }).toList(),
                  style: textStyle,
                  value: selectedValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
