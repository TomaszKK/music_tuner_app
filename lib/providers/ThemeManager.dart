import 'package:flutter/material.dart';

enum AppThemeType { light, dark }

class FontManager {
  static const String poppins = 'Poppins';
  static const String roboto = 'Roboto';
}

class ThemeManager with ChangeNotifier {
  ThemeData lightTheme = ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFE5E5E5),
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFFE5E5E5),
      primaryContainer: const Color(0xFFE5E5E5),
      onPrimaryContainer: const Color(0xFFE5E5E5),
      secondary: const Color(0xFFE5E5E5),
      secondaryContainer: const Color(0xFFE5E5E5),
      onSecondaryContainer: const Color(0xFFE5E5E5),
      background: const Color(0xFFE5E5E5),
      surface: const Color(0xFFE5E5E5),
      error: const Color(0xFFE5E5E5),
      onPrimary: const Color(0xFFE5E5E5),
      onSecondary: const Color(0xFFE5E5E5),
      onBackground: const Color(0xFFE5E5E5),
      onSurface: const Color(0xFFE5E5E5),
      onError: const Color(0xFFE5E5E5),
    ),
    scaffoldBackgroundColor: const Color(0xFFCEB1B1),
  );

  ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1E1E1E),
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF736B6B),
      onPrimary: const Color(0xFF081A02), //none
      primaryContainer: const Color(0xFF3C3535),
      onPrimaryContainer: const Color(0xFFFFFFFF),
      secondary: const Color(0xFF0AEF05),
      onSecondary: const Color(0xFFFE8C22),
      secondaryContainer: const Color(0xFFC03BFF),
      onSecondaryContainer: const Color(0xFFD177FF),
      background: const Color(0xFF322C2C),
      surface: const Color(0xFF1E1E1E),
      error: const Color(0xFF1E1E1E),
      onBackground: const Color(0xFF1E1E1E),
      onSurface: const Color(0xFF1E1E1E),
      onError: const Color(0xFF1E1E1E),
    ),
    scaffoldBackgroundColor: const Color(0xFF322C2C),
  );

  bool _isDark = true;

  ThemeData get currentTheme => _isDark ? darkTheme : lightTheme;

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}