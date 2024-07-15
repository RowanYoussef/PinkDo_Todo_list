import 'package:flutter/material.dart';
import 'package:pinkdo/Themes/theme.dart';
import 'package:pinkdo/Themes/themeNotifier.dart';

class ThemeProvider extends InheritedNotifier<ThemeNotifier> {
  final ThemeNotifier themeNotifier;

  ThemeProvider({
    Key? key,
    required Widget child,
    required this.themeNotifier,
  }) : super(key: key, notifier: themeNotifier, child: child);

  static ThemeNotifier of(BuildContext context, {required bool listen}) =>
      context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!.notifier!;

  @override
  bool updateShouldNotify(covariant InheritedNotifier<ThemeNotifier> oldWidget) {
    return true;
  }
}
