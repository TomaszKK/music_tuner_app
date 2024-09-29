import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_tuner/widgets/TranspositionWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/GuitarWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/BassWidget.dart';

import '../models/noteModel.dart';
import 'instrumentWidgetsDir/TenorhornWidget.dart';
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

  @override
  void initState() {
    super.initState();
    _loadNoteListForInstrument(widget.selectedInstrument);
  }

  // Load the note list based on the selected instrument
  void _loadNoteListForInstrument(String instrument) {
    String notePath;
    switch (instrument) {
      case 'Guitar':
      case 'Bass':
        notePath = 'lib/assets/notes.json';
        break;
      case 'Tenorhorn':
        notePath = 'lib/assets/notes-tenor.json';
        break;
      default:
        notePath = 'lib/assets/notes.json';
    }
    _loadNoteList(notePath);
  }

  Future<void> _loadNoteList(String notePath) async {
    String jsonString = await rootBundle.loadString(notePath);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    setState(() {
      noteFrequencyMap = jsonMap.map((key, value) => MapEntry(key, value.toDouble()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: TranspositionWidget.transpositionNotifier,
      builder: (context, transpositionNotify, child) {
        // Ensure the note list is loaded before proceeding
        if (noteFrequencyMap.isEmpty) {
          return const CircularProgressIndicator();
        }

        List<String> transposedNotes;
        switch (widget.selectedInstrument) {
          case 'Guitar':
            transposedNotes = transpositionChanged(transpositionNotify['Guitar']!, guitarDefaultNotes, 'Guitar');
            return Center(
              child: GuitarWidget(title: 'Guitar', noteList: transposedNotes),
            );
          case 'Bass':
            transposedNotes = transpositionChanged(transpositionNotify['Bass']!, bassDefaultNotes, 'Bass');
            return Center(
              child: BassWidget(title: 'Bass', noteList: transposedNotes),
            );
          case 'Tenorhorn':
            transposedNotes = transpositionChanged(transpositionNotify['Tenorhorn']!, tenorhornDefaultNotes, 'Tenorhorn');
            return Center(
              child: TenorhornWidget(title: 'Tenorhorn', noteList: transposedNotes),
            );
          default:
            return const Center(
              child: Text('No instrument selected'),
            );
        }
      },
    );
  }

  // This function transposes the notes based on the current instrument's transposition
  List<String> transpositionChanged(int transposition, List<String> noteList, String instrument) {
    List<String> newList = [];
    List<String> noteKeys = noteFrequencyMap.keys.toList();
    for (String note in noteList) {
      int currentIndex = noteKeys.indexOf(note);
      if (currentIndex == -1) {
        newList.add(note);
        continue;
      }

      // print('Transposition $transposition');

      int newIndex = currentIndex + transposition;

      if (newIndex >= noteKeys.length) {
        newIndex = noteKeys.length - 1;
        InstrumentWidget.isTranspositionBound.value = true;
      } else if (newIndex <= 1) {
        print("true");
        newIndex = 1;
        InstrumentWidget.isTranspositionBound.value = true;

      } else {
        print('false');
        InstrumentWidget.isTranspositionBound.value = false;
      }

      newList.add(noteKeys[newIndex]);
    }

    return newList;
  }
}
