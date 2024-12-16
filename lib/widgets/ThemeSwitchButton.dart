import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeManager.dart';

class ThemeSwitchButton extends StatelessWidget {
  const ThemeSwitchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return IconButton(
      icon: Icon(themeManager.isDark ? Icons.dark_mode : Icons.light_mode),
      onPressed: () {
        themeManager.switchTheme();
      },
    );
  }
}
