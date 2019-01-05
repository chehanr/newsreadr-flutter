import 'package:flutter/material.dart';

class CustomTheme {
  static final lightTheme = ThemeData(
    accentColor: Colors.indigoAccent,
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    
  );
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}
