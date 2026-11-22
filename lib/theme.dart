import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF121212); // Hitam Lembut
  static const Color card = Color(0xFF1E1E1E);       // Abu Gelap
  static const Color primary = Color(0xFFC9A227);    // Emas
  static const Color secondary = Color(0xFFE8C468);  // Emas Muda
  static const Color textPrimary = Color(0xFFFAF6F0); // Putih Gading
  static const Color textSecondary = Color(0xFFA89F91); // Abu Emas
  static const Color accent = Color(0xFFB4433A);     // Merah Wine
}

class AppTheme {
  static ThemeData get darkGoldTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.card,
        error: AppColors.accent,
        onPrimary: Color(0xFF121212),
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF333333)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: const Color(0xFF121212), // Teks gelap di atas tombol emas biar kontras kebaca
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}