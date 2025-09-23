import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kPrimary = Color(0xFF000000); // Uber Eats black
const kSecondary = Color(0xFF06C167); // Uber Eats green
const kBackground = Color(0xFFF8F8F8); // Light gray background

ThemeData buildLightTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kPrimary,
      primary: kPrimary,
      secondary: kSecondary,
      brightness: Brightness.light,
    ),
  );

  return base.copyWith(
    textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700),
      headlineSmall: GoogleFonts.inter(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400),
    ),
    scaffoldBackgroundColor: kBackground,
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
  );
}