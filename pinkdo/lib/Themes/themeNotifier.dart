import 'package:flutter/material.dart';
import 'package:pinkdo/Themes/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  late SharedPreferences prefs;
  final String ThemeKey = 'selectedTheme';
  late ThemeData _currentTheme;

  ThemeNotifier() {
    _currentTheme = MyAppThemes().PinkTheme;
    _initializePreferences();
  }

  ThemeData get currentTheme => _currentTheme;

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadTheme();
  }

  void toggleTheme() {
    _currentTheme = isBlue()
        ? MyAppThemes().PinkTheme
        : MyAppThemes().blueTheme;
    saveTheme();
    notifyListeners();
  }

  void loadTheme() {
    String? themeName = prefs.getString(ThemeKey);
    if (themeName == 'pink') {
      _currentTheme = MyAppThemes().PinkTheme;
    } else {
      _currentTheme = MyAppThemes().blueTheme;
    }
    notifyListeners();
  }

  void saveTheme() {
    prefs.setString(
        ThemeKey, _currentTheme == MyAppThemes().blueTheme ? 'blue' : 'pink');
  }

  bool isBlue() {
    return _currentTheme == MyAppThemes().blueTheme;
  }
}
