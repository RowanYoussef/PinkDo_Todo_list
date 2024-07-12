import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:pinkdo/screens/Task.dart';
import 'package:pinkdo/screens/TodoList.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => TodoList(),
    '/Task' : (task) => Task(),
  },
));

