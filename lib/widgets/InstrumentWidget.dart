import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/GuitarWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/BassWidget.dart';

import 'instrumentWidgetsDir/TenorhornWidget.dart';

class InstrumentWidget extends StatefulWidget {
  const InstrumentWidget({Key? key, required this.title, required this.selectedInstrument}) : super(key: key);

  final String title;
  final String selectedInstrument;
  static ValueNotifier<String> noteListNotifier = ValueNotifier<String>('');

  @override
  State<InstrumentWidget> createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> {
  String currentInstrument = '';

  @override
  Widget build(BuildContext context) {
    switch(widget.selectedInstrument){
      case 'Guitar':
        currentInstrument = 'Guitar';
        InstrumentWidget.noteListNotifier.value = 'lib/assets/notes.json';
        return const Center(
          child: GuitarWidget(title: 'Guitar'),
        );
      case 'Bass':
        currentInstrument = 'Bass';
        InstrumentWidget.noteListNotifier.value = 'lib/assets/notes.json';
        return const Center(
          child: BassWidget(title: 'Bass'),
        );
      case 'Tenorhorn':
        currentInstrument = 'Tenorhorn';
        InstrumentWidget.noteListNotifier.value = 'lib/assets/notes-tenor.json';
        return const Center(
          child: TenorhornWidget(title: 'Tenorhorn'),
        );
      default:
        currentInstrument = 'Guitar';
        InstrumentWidget.noteListNotifier.value = 'lib/assets/notes.json';
        return const GuitarWidget(title: 'Guitar');
    }
  }
}
