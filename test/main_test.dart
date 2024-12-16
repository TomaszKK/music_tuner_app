import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_tuner/main.dart'; // Import your main.dart
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/HomePage.dart';
import 'package:provider/provider.dart';

void main() {
  group('Main App Tests', () {
    testWidgets('App launches and displays HomePage', (WidgetTester tester) async {
      // Mock the ThemeManager
      final themeManager = ThemeManager();

      // Wrap the app in a mock ChangeNotifierProvider
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      // Ensure the MaterialApp and HomePage are rendered
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);

      // Check if the title on the HomePage appears
      expect(find.text('Instrument Tuner'), findsOneWidget);
    });

    testWidgets('App applies light theme by default', (WidgetTester tester) async {
      final themeManager = ThemeManager();

      // Wrap the app in the mock provider
      await tester.pumpWidget(
        ChangeNotifierProvider<ThemeManager>.value(
          value: themeManager,
          child: const MyApp(),
        ),
      );

      final BuildContext context = tester.element(find.byType(HomePage));
      final ThemeData theme = Theme.of(context);

      expect(theme.brightness, Brightness.dark);
    });
  });
}
