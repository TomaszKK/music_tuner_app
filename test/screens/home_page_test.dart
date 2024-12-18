import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_tuner/screens/HomePage.dart';
import 'package:music_tuner/widgets/InstrumentWidget.dart';
import 'package:music_tuner/widgets/TopBar/BluetoothButton.dart';
import 'package:music_tuner/widgets/TopBar/SettingsButton.dart';
import 'package:music_tuner/widgets/TopBar/TranspositionButton.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';

void main() {
  testWidgets('HomePage renders correctly with AppBar and content', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomePage(title: 'Music Tuner')));

    expect(find.text('Music Tuner'), findsOneWidget);

    expect(find.byType(TranspositionButton), findsOneWidget);
    expect(find.byType(BluetoothButton), findsOneWidget);
    expect(find.byType(SettingsButton), findsOneWidget);
    expect(find.byType(TunerWidget), findsOneWidget);
    expect(find.byType(InstrumentWidget), findsOneWidget);
  });
}
