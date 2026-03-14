import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Exact color tokens from the React App's index.css :root variables
class AppColors {
  // Dark theme (default)
  static const bgColor = Color(0xFF0F172A);
  static const cardBg = Color(0xFF1E293B); // rgba(30,41,59,0.7)
  static const cardBorder = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
  static const textMain = Color(0xFFF8FAFC);
  static const textMuted = Color(0xFF94A3B8);
  static const accentColor = Color(0xFF6366F1);
  static const accentLight = Color(0xFF818CF8);
  static const accentPurple = Color(0xFFA855F7);
  static const success = Color(0xFF10B981);
  static const successBg = Color(0x1A10B981); // rgba(16,185,129,0.1)
  static const danger = Color(0xFFEF4444);
  static const dangerBg = Color(0x1AEF4444); // rgba(239,68,68,0.1)
  static const warning = Color(0xFFFACC15);
  static const warningBg = Color(0x1AFACC15);

  // Light theme overrides
  static const bgColorLight = Color(0xFFF8FAFC);
  static const cardBgLight = Color(0xBFFFFFFF); // rgba(255,255,255,0.75)
  static const cardBorderLight = Color(0x1A000000);
  static const textMainLight = Color(0xFF0F172A);
  static const textMutedLight = Color(0xFF475569);
  static const accentColorLight = Color(0xFF4F46E5);

  static const accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
  );
}

ThemeData buildDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgColor,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accentColor,
      secondary: AppColors.accentPurple,
      surface: AppColors.cardBg,
      error: AppColors.danger,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: AppColors.textMain,
      ),
      iconTheme: IconThemeData(color: AppColors.textMuted),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg.withAlpha(180),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0x33000000), // rgba(0,0,0,0.2)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.accentColor, width: 2),
      ),
      labelStyle: const TextStyle(color: AppColors.textMuted),
      prefixIconColor: AppColors.textMuted,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accentColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentColor,
      foregroundColor: Colors.white,
    ),
  );
}

ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgColorLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accentColorLight,
      secondary: AppColors.accentPurple,
      surface: AppColors.cardBgLight,
      error: AppColors.danger,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: AppColors.textMainLight,
      ),
      iconTheme: IconThemeData(color: AppColors.textMutedLight),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBgLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.cardBorderLight),
      ),
      elevation: 0,
    ),
  );
}
