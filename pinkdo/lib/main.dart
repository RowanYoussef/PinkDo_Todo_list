import 'package:flutter/material.dart';
import 'package:pinkdo/Themes/theme.dart';
import 'package:pinkdo/Themes/themeNotifier.dart';
import 'package:pinkdo/database/sql.dart';
import 'package:pinkdo/screens/Task.dart';
import 'package:pinkdo/screens/TodoList.dart';
import 'package:pinkdo/screens/Wish.dart';
import 'package:pinkdo/screens/wish_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, _) => MaterialApp(
        title: 'My App',
        theme: themeNotifier.currentTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => TodoList(),
          '/Task': (context) => Task(),
          '/WishList': (context) => WishList(),
          '/Wish': (context) => Wish(),
        },
      ),
    );
  }
}

