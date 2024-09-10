import 'package:flutter/material.dart';
import 'package:habit/theme/dark_theme.dart';
import 'package:habit/theme/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  // initial light mode

  ThemeData _themeData = lightMode;

  // get curren theme

  ThemeData get themeData => _themeData;

  // current mode is dark

  bool get isDarkMode => _themeData == darkMode;

//setter
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners(); // Notify listeners when the theme changes
  }

  //toggle
  void toggelTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
