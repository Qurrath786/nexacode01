import 'package:flutter/material.dart';

ThemeData nexaTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  fontFamily: 'FiraCode',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.greenAccent,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'FiraCode'),
    bodySmall: TextStyle(color: Colors.white70, fontFamily: 'FiraCode'),
  ),
  iconTheme: const IconThemeData(color: Colors.greenAccent),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.black,
    hintStyle: const TextStyle(color: Colors.white54),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
);
