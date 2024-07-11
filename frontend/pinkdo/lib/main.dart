import 'package:pinkdo/pages/LogIn.dart';
import 'package:pinkdo/pages/SignUp.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Login(),
    '/SignUp' : (context) => SignUp(),
  },
));
