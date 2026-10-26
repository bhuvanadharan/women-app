import 'package:flutter/material.dart';

/// Shared visual tokens for Aster.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF185B50);
  static const primaryGrey = Color(0xFF18342F);
  static const accent = Color(0xFFD7F17A);
  static const danger = Color(0xFFD9574D);
  static const page = Color(0xFFF5F6F2);
  static const surface = Color(0xFFFFFFFF);
  static const neutral200 = Color(0xFFE6EAE5);
  static const neutral300 = Color(0xFFD5DDD6);
  static const neutral400 = Color(0xFFA3B0A8);
  static const neutral900 = Color(0xFF56635D);
  static const fieldFill = Color(0xFFF1F4F0);
  static const navBackground = Color(0xFFFFFFFF);
  static const navInactive = Color(0xFF78857E);
  static const dot = Color(0xFFD5DDD6);
  static const black = Color(0xFF182A26);
}

class AppRadius {
  AppRadius._();

  static const r4 = 8.0;
  static const r5 = 10.0;
  static const r6 = 12.0;
  static const r12 = 24.0;
}

class AppTextStyles {
  AppTextStyles._();

  static const _base = TextStyle(color: AppColors.black, height: 1.0);

  static final h5 = _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 38 / 32,
  );
  static final calloutBold = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.32,
  );
  static final b1 = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 27 / 18,
  );
  static final b2 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );
  static final b3 = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 21 / 14,
  );
  static final b4 = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 18 / 12,
  );
  static final b5 = _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 15 / 10,
  );
  static final semibold16 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 15 / 16,
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.page,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.danger,
      brightness: Brightness.light,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.page,
      foregroundColor: AppColors.black,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r6),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r6),
        borderSide: const BorderSide(color: AppColors.neutral200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.r6),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(57),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r6),
        ),
        textStyle: AppTextStyles.b1,
        elevation: 0,
      ),
    ),
  );
}
