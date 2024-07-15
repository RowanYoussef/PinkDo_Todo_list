import 'package:flutter/material.dart';

class MyAppThemes {
  //blue theme
  final ThemeData blueTheme = ThemeData(
    primaryColor: Colors.blue.shade300,
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade200,
      secondary: Colors.blue.shade100,
      surface: Colors.blue.shade50,
    ),
  );
 //pink theme
    final ThemeData PinkTheme = ThemeData(
    primaryColor: Colors.pink.shade300,
    scaffoldBackgroundColor: Colors.pink[50],
    colorScheme: ColorScheme.light(
      primary: Colors.pink.shade200,
      secondary: Colors.pink.shade100,
      surface: Colors.pink.shade50,
    ),
  );
    ThemeData getTheme(bool isblue) {
    return isblue ? blueTheme : PinkTheme;
  }
}
