import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:music_tuner/widgets/DatabaseHelper.dart';
import 'package:provider/provider.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/HomePage.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final themeMode = await fetchInitialThemeMode();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(initialThemeMode: themeMode),
      child: const MyApp(),
    ),
  );

  FlutterNativeSplash.remove();
}

Future<bool> fetchInitialThemeMode() async {
  final dbHelper = DatabaseHelper();
  final settings = await dbHelper.getSettings();

  if (settings != null && settings['theme_mode'] != null) {
    final themeMode = settings['theme_mode'];
    if (themeMode == 'light') return false;
    if (themeMode == 'dark') return true;
  }

  return true;
  // Default theme mode
  // return ThemeMode.system;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Tuner',
      theme: themeManager.currentTheme,
      home: HomePage(title: 'Tuner.'),
    );
  }
}
