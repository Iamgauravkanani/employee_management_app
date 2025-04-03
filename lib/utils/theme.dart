import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1DA1F2);
  static const Color secondaryColor = Color(0xFF3F37C9);
  static const Color accentColor = Color(0xFF4895EF);
  static const Color errorColor = Color(0xFFF72585);
  static const Color successColor = Color(0xFF4CC9F0);
  static const Color lightBackgroundColor = Color(0xFFF8F9FA);
  static const Color lightCardColor = Colors.white;
  static const Color lightTextColor = Color(0xFF212529);
  static const Color textColor = Color(0xFF323238);

  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkCardColor = Color(0xFF1E1E1E);
  static const Color darkTextColor = Colors.white;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    cardColor: lightCardColor,

    textTheme: GoogleFonts.robotoTextTheme().copyWith(
      headlineLarge: GoogleFonts.roboto(fontSize: 28, fontWeight: FontWeight.w800, color: lightTextColor),
      headlineMedium: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.w700, color: lightTextColor),
      headlineSmall: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w600, color: lightTextColor),
      titleLarge: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600, color: lightTextColor),
      titleMedium: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500, color: lightTextColor),
      titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: lightTextColor),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400, color: lightTextColor),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400, color: lightTextColor),
      bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400, color: lightTextColor),
      labelLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightCardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    cardColor: darkCardColor,
    textTheme: GoogleFonts.poppinsTextTheme().apply(bodyColor: darkTextColor, displayColor: darkTextColor),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCardColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
