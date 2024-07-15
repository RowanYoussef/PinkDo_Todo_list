import 'package:flutter/material.dart';
import 'package:pinkdo/Themes/theme.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = MyAppThemes().PinkTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme =  _currentTheme == MyAppThemes().blueTheme ? MyAppThemes().PinkTheme : MyAppThemes().blueTheme;
    notifyListeners(); 
  }
}