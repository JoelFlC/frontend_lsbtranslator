import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static TextTheme _getBaseTextTheme() {
    try {
      return GoogleFonts.getTextTheme('Geist');
    } catch (e) {
      return GoogleFonts.interTextTheme();
    }
  }

  static TextTheme _getMonoTextTheme() {
    try {
      return GoogleFonts.getTextTheme('JetBrains Mono');
    } catch (e) {
      return GoogleFonts.robotoMonoTextTheme();
    }
  }

  static ThemeData get lightTheme {
    final baseTextTheme = _getBaseTextTheme();
    final monoTextTheme = _getMonoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.onPrimaryLight,
        primaryContainer: AppColors.primaryContainerLight,
        onPrimaryContainer: AppColors.onPrimaryContainerLight,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.onSecondaryLight,
        secondaryContainer: AppColors.secondaryContainerLight,
        onSecondaryContainer: AppColors.onSecondaryContainerLight,
        tertiary: AppColors.secondaryLight, // Use Teal for Mic in Light Mode
        onTertiary: AppColors.onSecondaryLight,
        tertiaryContainer: AppColors.secondaryContainerLight,
        onTertiaryContainer: AppColors.secondaryLight,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -0.02, color: AppColors.onSurfaceLight,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: -0.01, color: AppColors.onSurfaceLight,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurfaceLight,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.onSurfaceLight,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.onSurfaceLight,
        ),
        labelSmall: monoTextTheme.labelSmall?.copyWith(
          fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.05, color: AppColors.onSurfaceVariantLight,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowestLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariantLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariantLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariantLight),
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowestLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.surfaceContainerHighLight, width: 1),
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowestLight,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.onSurfaceVariantLight,
        elevation: 8,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = _getBaseTextTheme();
    final monoTextTheme = _getMonoTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.onPrimaryContainerDark,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.onSecondaryDark,
        secondaryContainer: AppColors.secondaryContainerDark,
        onSecondaryContainer: AppColors.onSecondaryContainerDark,
        tertiary: AppColors.primaryDark, // Use Mint for Mic in Dark Mode
        onTertiary: AppColors.onPrimaryDark,
        tertiaryContainer: AppColors.primaryContainerDark,
        onTertiaryContainer: AppColors.onPrimaryContainerDark,
        error: AppColors.error,
        onError: AppColors.onError,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      
      textTheme: baseTextTheme.copyWith(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -0.02, color: AppColors.onSurfaceDark,
        ),
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: -0.01, color: AppColors.onSurfaceDark,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.onSurfaceDark,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 18, fontWeight: FontWeight.w400, color: AppColors.onSurfaceDark,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 16, fontWeight: FontWeight.w400, height: 1.5, color: AppColors.onSurfaceDark,
        ),
        labelSmall: monoTextTheme.labelSmall?.copyWith(
          fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.05, color: AppColors.onSurfaceVariantDark,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainerDark,
          foregroundColor: AppColors.onPrimaryContainerDark,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.surfaceContainerHighDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.surfaceContainerHighDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primaryDark),
        ),
        contentPadding: const EdgeInsets.all(16),
        hintStyle: const TextStyle(color: AppColors.outlineVariantDark),
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.surfaceContainerLowDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.surfaceContainerHighDark, width: 1),
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceContainerLowestDark,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.onSurfaceVariantDark,
        elevation: 0,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryDark),
      ),
    );
  }
}
