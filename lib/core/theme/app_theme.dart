import 'package:flutter/material.dart';

class AppTheme {
  static const orange = Color(0xFFFF6A00);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: orange, primary: orange),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: orange, foregroundColor: Colors.white),
        filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: orange, foregroundColor: Colors.white)),
      );
}
