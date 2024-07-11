import 'package:flutter/material.dart';
import 'package:pinkdo/screens/TodoList.dart';

void main() => runApp(pinkdo());

class pinkdo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinkDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pink.shade200,
      ),
      home: TodoList(),
    );
  }
}
