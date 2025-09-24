import 'package:flutter/material.dart';
class AppTheme {
  static const orange = Color(0xFFFF6A00);
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: orange, primary: orange),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black),
    cardTheme: CardThemeData(color: Colors.white, elevation: 0.5, surfaceTintColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(selectedItemColor: orange, unselectedItemColor: Colors.black54, showUnselectedLabels: true),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: orange, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16)))
  );
}
