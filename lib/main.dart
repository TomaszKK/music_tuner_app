import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import to control system settings
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/HomePage.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Lock the orientation to portrait during launch
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    // Remove the splash screen and allow screen rotation
    FlutterNativeSplash.remove();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return MaterialApp(
      title: 'Instrument Tuner',
      theme: themeManager.currentTheme,
      home: HomePage(title: 'Instrument Tuner'),
    );
  }
}
