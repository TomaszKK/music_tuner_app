import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/HomePage.dart';


Future<void> main() async {
  // await Supabase.initialize(
  //   url: "https://dztzkgkgseuwkvagclqu.supabase.co",
  //   anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR6dHprZ2tnc2V1d2t2YWdjbHF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgwMTk5NzMsImV4cCI6MjAyMzU5NTk3M30.5Gt90zdZ9IuRhQDwOLCWxC2GACOkreUxjfVmmf3pYmM",
  // );
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
    FlutterNativeSplash.remove();
    return MaterialApp(
      title: 'Instrument Tuner',
      theme: themeManager.currentTheme,
      home: const HomePage(title: 'Instrument Tuner'),
    );
  }
}




