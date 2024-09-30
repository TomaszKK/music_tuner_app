import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_tuner/widgets/TranspositionWidget.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/GuitarWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/BassWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/TenorhornWidget.dart';

import '../models/noteModel.dart';
import '../screens/HomePage.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';

class InstrumentWidget extends StatefulWidget {
  const InstrumentWidget({Key? key, required this.title, required this.selectedInstrument}) : super(key: key);

  final String title;
  final String selectedInstrument;

  static ValueNotifier<String> noteListNotifier = ValueNotifier<String>('');
  static ValueNotifier<bool> isTranspositionBound = ValueNotifier<bool>(false);

  @override
  State<InstrumentWidget> createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> {
  Map<String, double> noteFrequencyMap = {};
  final Map<String, String> instrumentNoteFiles = {
    'Guitar': 'lib/assets/notes.json',
    'Bass': 'lib/assets/notes.json',
    'Tenorhorn': 'lib/assets/notes-tenor.json',
  };

  final Map<String, Widget Function(String, List<String>, Function(List<String>))> instrumentWidgets = {
    'Guitar': (title, notes, onNotesChanged) => GuitarWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
    'Bass': (title, notes, onNotesChanged) => BassWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
    'Tenorhorn': (title, notes, onNotesChanged) => TenorhornWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
  };

  @override
  void initState() {
    super.initState();
    _loadNoteListForInstrument(widget.selectedInstrument);
  }

  Future<void> _loadNoteListForInstrument(String instrument) async {
    String notePath = instrumentNoteFiles[instrument] ?? 'lib/assets/notes.json';
    String jsonString = await rootBundle.loadString(notePath);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      noteFrequencyMap = jsonMap.map((key, value) => MapEntry(key, value.toDouble()));
    });
  }

  void _updateInstrumentNotesMap(List<String> updatedNotes) {
    setState(() {
      instrumentNotesMap[widget.selectedInstrument] = updatedNotes;
      manualNotesMap[widget.selectedInstrument] = updatedNotes;
      HomePage.isResetVisible.value[widget.selectedInstrument] = true;
      HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
    });
  }

  List<String> _handleInstrumentNotes(String instrument, bool isNoteChanged) {
    if (isNoteChanged) {
      // Reset the transposition and load default notes
      final String defaultInstrument = instrument.toLowerCase();
      TranspositionWidget.transpositionNotifier.value[instrument] = 0;
      instrumentNotesMap[instrument] = List<String>.from(noteInstrumentDefaultProvider[instrument]!);
      manualNotesMap[instrument] = List<String>.from(noteInstrumentDefaultProvider[instrument]!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomePage.isNoteChanged.value = false;
        TunerWidget.blockedNoteNotifier.value = '';
      });
    }
    instrumentNotesMap[instrument] = transpositionChanged(TranspositionWidget.transpositionNotifier.value[instrument]!, instrumentNotesMap[instrument]!, instrument);
    TranspositionWidget.transpositionNotifier.value[instrument] = 0;
    return instrumentNotesMap[instrument]!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomePage.isNoteChanged,
      builder: (context, isNoteChanged, child) {
        return ValueListenableBuilder(
          valueListenable: TranspositionWidget.transpositionNotifier,
          builder: (context, transpositionNotify, child) {
            if (noteFrequencyMap.isEmpty) {
              return const CircularProgressIndicator();
            }

            final instrument = widget.selectedInstrument;

            // Handle the notes based on the selected instrument
            List<String> transposedNotes = _handleInstrumentNotes(instrument, isNoteChanged);

            // Create the appropriate instrument widget
            final instrumentWidget = instrumentWidgets[instrument]?.call(instrument, transposedNotes, _updateInstrumentNotesMap);

            return Center(
              child: instrumentWidget ?? const Center(child: Text('No instrument selected')),
            );
          },
        );
      },
    );
  }

  // This function transposes the notes based on the current instrument's transposition
  List<String> transpositionChanged(int transpositionStep, List<String> noteList, String instrument) {
    List<String> newList = [];
    List<String> noteKeys = noteFrequencyMap.keys.toList();

    for (String note in noteList) {
      int currentIndex = noteKeys.indexOf(note);

      if (currentIndex == -1) {
        newList.add(note);
        continue;
      }

      int newIndex = currentIndex + transpositionStep;

      if (newIndex >= noteKeys.length) {
        newIndex = noteKeys.length - 1;
        InstrumentWidget.isTranspositionBound.value = true;
      } else if (newIndex < 0) {
        newIndex = 0;
        InstrumentWidget.isTranspositionBound.value = true;
      } else {
        InstrumentWidget.isTranspositionBound.value = false;
      }

      newList.add(noteKeys[newIndex]);
    }

    return newList;
  }
}
