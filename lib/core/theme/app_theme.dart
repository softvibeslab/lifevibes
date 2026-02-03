import 'package:flutter/material.dart';

/// LifeVibes color palette - Gamified theme
class AppColors {
  // Primary colors (LifeVibes brand)
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF4B44A8);
  static const Color primaryLight = Color(0xFF9D97FF);

  // Secondary colors
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryDark = Color(0xFFD64A4A);
  static const Color secondaryLight = Color(0xFFFFB8B8);

  // Background colors
  static const Color background = Color(0xFF1A1A2E);
  static const Color surface = Color(0xFF16213E);
  static const Color card = Color(0xFF0F3460);

  // Text colors
  static const Color textPrimary = Color(0xFFEAEAEA);
  static const Color textSecondary = Color(0xFFB8B8B8);
  static const Color textTertiary = Color(0xFF888888);

  // Gamification colors
  static const Color xp = Color(0xFFFFD93D);
  static const Color level = Color(0xFF6BCB77);
  static const Color badge = Color(0xFF4D96FF);
  static const Color health = Color(0xFFFF6B6B);
  static const Color energy = Color(0xFF4ECDC4);
  static const Color happiness = Color(0xFFFFD93D);

  // Avatar superpowers colors
  static const Color powerStrength = Color(0xFFFF6B6B);
  static const Color powerIntelligence = Color(0xFF4D96FF);
  static const Color powerCreativity = Color(0xFFFFD93D);
  static const Color powerCharisma = Color(0xFF6BCB77);
  static const Color powerWisdom = Color(0xFF9B59B6);

  // Superpower skill colors
  static const Color skillCreatividad = Color(0xFFFFA500);
  static const Color skillInnovación = Color(0xFF4D96FF);
  static const Color skillComunicación = Color(0xFFFF6B6B);
  static const Color skillLiderazgo = Color(0xFF6BCB77);
  static const Color skillTecnología = Color(0xFF4D96FF);
  static const Color skillDiseño = Color(0xFFFFD93D);
  static const Color skillNegociación = Color(0xFFFF6B6B);
  static const Color skillAnálisis = Color(0xFF4D96FF);
  static const Color skillEstrategia = Color(0xFF9B59B6);

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient xpGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFD93D), Color(0xFFFFAA00)],
  );

  static const LinearGradient levelGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF6BCB77), Color(0xFF2ECC71)],
  );
}

/// App theme
class AppTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.secondary,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.card,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 57,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),
  );
}
