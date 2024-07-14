import 'package:flutter/material.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:pinkdo/screens/Task.dart';
import 'package:pinkdo/screens/TodoList.dart';
import 'package:pinkdo/screens/Wish.dart';
import 'package:pinkdo/screens/wish_list.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => TodoList(),
    '/Task' : (context) => Task(),
    '/WishList': (context) => WishList(),
    '/Wish': (context) => Wish()

  },
));

