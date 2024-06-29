import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff80ADD7),
  onPrimary: Colors.white,
  secondary: Color(0xff00C2FF),
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  background: Colors.white,
  onBackground: Colors.black,
  surface: Color(0xFFFEF7FF),
  onSurface: Colors.black,
  onTertiary: Color(0xFFD5D1DB),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 50, 63, 75),
  onPrimary: Colors.white,
  secondary: Color.fromARGB(255, 80, 128, 143),
  onSecondary: Colors.white,
  error: Colors.redAccent,
  onError: Colors.black,
  background: Color(0xFF121212),
  onBackground: Colors.white,
  surface: Color(0xFF1E1E1E),
  onSurface: Colors.white,
  onTertiary: Color.fromARGB(255, 77, 97, 104),
);

class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = false;

  ThemeData get themeData => _isDarkMode
      ? ThemeData.from(colorScheme: darkColorScheme)
      : ThemeData.from(colorScheme: lightColorScheme);

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
