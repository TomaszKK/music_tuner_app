import 'package:flutter/material.dart';
import 'package:music_tuner/utils/color_schemes.dart';
import 'package:music_tuner/utils/font_manager.dart';

class ThemeManager with ChangeNotifier {
  bool _isDark = true; // Theme state

  ThemeManager({required bool initialThemeMode}) {
    _isDark = initialThemeMode;
  }

  // Light Theme
  ThemeData get lightTheme => ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.lightPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondaryContainer: AppColors.lightOnSecondaryContainer,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      error: AppColors.lightError,
      onPrimary: AppColors.lightOnPrimary,
      onSecondary: AppColors.lightOnSecondary,
      onBackground: AppColors.lightOnBackground,
      onSurface: AppColors.lightOnSurface,
      onError: AppColors.lightOnError,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    textTheme: const TextTheme(
      headlineLarge: FontManager.headingStyle,
      bodyLarge: FontManager.bodyStyle,
    ),
  );

  // Dark Theme
  ThemeData get darkTheme => ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkOnSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      error: AppColors.darkError,
      onBackground: AppColors.darkOnBackground,
      onSurface: AppColors.darkOnSurface,
      onError: AppColors.darkOnError,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: const TextTheme(
      headlineLarge: FontManager.headingStyle,
      bodyLarge: FontManager.bodyStyle,
    ),
  );

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }

  bool get isDark => _isDark;
}

