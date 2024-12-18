import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_tuner/providers/NoteProvider.dart';
import 'package:music_tuner/widgets/TranspositionWidget.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/GuitarWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/BassWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/TenorhornWidget.dart';

import '../providers/InstrumentProvider.dart';
import '../providers/noteAdditionalProvider.dart';
import '../screens/HomePage.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';

import 'DatabaseHelper.dart';
import 'instrumentWidgetsDir/SaxophoneWidget.dart';
import 'instrumentWidgetsDir/TrumpetWidget.dart';

class InstrumentWidget extends StatefulWidget {
  const InstrumentWidget({super.key, required this.title, required this.selectedInstrument});

  final String title;
  final String selectedInstrument;

  static ValueNotifier<String> noteListNotifier = ValueNotifier<String>('');
  static ValueNotifier<bool> isTranspositionBound = ValueNotifier<bool>(false);

  @override
  State<InstrumentWidget> createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> with WidgetsBindingObserver {
  Map<String, double> noteFrequencyMap = {};

  final Map<String, Widget Function(String, List<String>, Function(List<String>))> instrumentWidgets = {
    'Guitar': (title, notes, onNotesChanged) => GuitarWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
    'Bass': (title, notes, onNotesChanged) => BassWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
    'Tenorhorn': (title, notes, onNotesChanged) => TenorhornWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
    'Saxophone': (title, notes, onNotesChanged) => SaxophoneWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
    'Trumpet': (title, notes, onNotesChanged) => TrumpetWidget(title: title, noteList: notes, onNotesChanged: onNotesChanged),
  };

  @override
  void initState() {
    super.initState();
    _loadAppState();
    _loadNoteListForInstrument(widget.selectedInstrument);
    WidgetsBinding.instance.addObserver(this);
  }


  Future<void> _loadAppState() async {
    var settings = await DatabaseHelper().getSettings();
    if (settings != null) {
      setState(() {
        String transpositionJson = settings['transposition_notifier'] ?? '{}';
        TranspositionWidget.transpositionNotifier.value = Map<String, int>.from(jsonDecode(transpositionJson));
        String instrumentNotesJson = settings['instrument_notes'] ?? '{}';  // Default to empty map
        Map<String, dynamic> instrumentNotesMapDynamic = jsonDecode(instrumentNotesJson);
        instrumentNotesMap = {
          for (var key in instrumentNotesMapDynamic.keys)
            key: List<String>.from(instrumentNotesMapDynamic[key])  // Convert each entry to List<String>
        };

        // Parse manual notes JSON
        String manualNotesJson = settings['manual_notes'] ?? '{}';  // Default to empty map
        Map<String, dynamic> manualNotesMapDynamic = jsonDecode(manualNotesJson);
        manualNotesMap = {
          for (var key in manualNotesMapDynamic.keys)
            key: List<String>.from(manualNotesMapDynamic[key])  // Convert each entry to List<String>
        };
      });
    }
  }

  Future<void> _saveAppState() async {
    await DatabaseHelper().insertOrUpdateInstrumentsSettings(
      TranspositionWidget.transpositionNotifier.value,
      instrumentNotesMap,
      manualNotesMap
    );
  }

  void _resetAllChanges() {
    setState(() {
      TranspositionWidget.transpositionNotifier.value = {
        for (var instrument in InstrumentProvider.values) instrument.name: 0,
      };
      _saveAppState();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveAppState();  // Save app state when app is paused or inactive
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);  // Remove observer on dispose
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InstrumentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the selectedInstrument has changed
    if (oldWidget.selectedInstrument != widget.selectedInstrument) {
      // Reload notes for the new instrument
      _loadNoteListForInstrument(widget.selectedInstrument);
      _saveAppState();
    }
  }

  Future<void> _loadNoteListForInstrument(String instrument) async {
    setState(() {
      noteFrequencyMap = NoteProvider().getNotes(instrument);
      selectedInstrumentNotesMap = noteFrequencyMap;
    });
  }

  void _updateInstrumentNotesMap(List<String> updatedNotes) {
    setState(() {
      instrumentNotesMap[widget.selectedInstrument] = updatedNotes;
      manualNotesMap[widget.selectedInstrument] = updatedNotes;
      HomePage.isResetVisible.value[widget.selectedInstrument] = true;
      HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
      _saveAppState();
    });
  }

  List<String> _handleInstrumentNotes(String instrument, bool isNoteChanged) {
    if (isNoteChanged) {
      TranspositionWidget.transpositionNotifier.value[instrument] = 0;
      instrumentNotesMap[instrument] = List<String>.from(noteInstrumentDefaultProvider[instrument]!);
      manualNotesMap[instrument] = List<String>.from(noteInstrumentDefaultProvider[instrument]!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomePage.isNoteChanged.value = false;
        TunerWidget.blockedNoteNotifier.value = '';
      });
      _saveAppState();
    }
    instrumentNotesMap[instrument] = transpositionChanged(TranspositionWidget.transpositionNotifier.value[instrument]!, instrumentNotesMap[instrument]!, instrument);
    TranspositionWidget.transpositionNotifier.value[instrument] = 0;
    _saveAppState();
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
            _saveAppState();
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
      } else if (newIndex < 1) {
        newIndex = 1;
        InstrumentWidget.isTranspositionBound.value = true;
      } else {
        InstrumentWidget.isTranspositionBound.value = false;
      }

      String checkNote = resolveEnharmonic(noteKeys[newIndex]);
      newList.add(checkNote);
    }

    int i = 0;
    List<bool> isNoteDefault = [];
    for(String note in newList){
      if(note == noteInstrumentDefaultProvider[instrument]![i]){
        isNoteDefault.add(true);
      }
      else{
        isNoteDefault.add(false);
      }
      i++;
    }

    if(isNoteDefault.contains(false)){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomePage.isResetVisible.value[instrument] = true;
        HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
      });
    } else{
      WidgetsBinding.instance.addPostFrameCallback((_) {
        HomePage.isResetVisible.value[instrument] = false;
        HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
      });
    }

    return newList;
  }
}
