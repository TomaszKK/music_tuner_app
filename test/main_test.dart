import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_tuner/main.dart'; // Import your main.dart
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/HomePage.dart';
import 'package:music_tuner/widgets/body/LandscapeLayoutWidget.dart';
import 'package:music_tuner/widgets/body/PortraitLayoutWidget.dart';
import 'package:provider/provider.dart';
import 'package:fake_async/fake_async.dart';

void main() {
  group('Main App Tests', () {
    testWidgets('App launches and displays HomePage', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('App launches and displays HomePage in dark mode', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      expect(themeManager.currentTheme.brightness, Brightness.dark);
    });

    testWidgets('App launches and displays HomePage in light mode', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      themeManager.switchTheme();

      expect(themeManager.currentTheme.brightness, Brightness.light);
    });

    testWidgets('App launches and displays HomePage in dark mode after switching theme', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      themeManager.switchTheme();
      themeManager.switchTheme();

      expect(themeManager.currentTheme.brightness, Brightness.dark);
    });

    testWidgets('App launches in portrait mode', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);

      expect(
        MediaQuery.of(tester.element(find.byType(HomePage))).orientation,
        Orientation.portrait,
      );

      addTearDown(tester.view.reset);
    });

    testWidgets('App launches in landscape mode', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;


      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);

      expect(
        MediaQuery.of(tester.element(find.byType(HomePage))).orientation,
        Orientation.landscape,
      );

      addTearDown(tester.view.reset);
    });
  });
}
