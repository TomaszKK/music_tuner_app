import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../screens/SettingsPage.dart';
import 'BluetoothConnectorWidget.dart';
import 'package:music_tuner/models/NoteModel.dart';

import 'DatabaseHelper.dart';
import 'FrequencyButtonWidget.dart';
import 'NoteRepresentationWidget.dart';

class TunerWidget extends StatefulWidget {
  TunerWidget({super.key, required this.title, required this.selectedInstrument});

  final String title;
  final String selectedInstrument;


  static ValueNotifier<String> currentNoteNotifier = ValueNotifier<String>('');
  static ValueNotifier<String> blockedNoteNotifier = ValueNotifier<String>('');

  @override
  State<TunerWidget> createState() => _TunerWidgetState();
}

class _TunerWidgetState extends State<TunerWidget> {
  String frequencyText = '0.0';
  String currentNote = '';
  String textUnderNote = '';
  double initialFrequency = 440.0;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, () {
      _loadAppState();
    // });
  }

  Future<void> _loadAppState() async {
    var settings = await DatabaseHelper().getSettings();
    if (settings != null) {
      // setState(() {
      initialFrequency = settings['frequency'] ?? 0;
      // });
    }
  }

  Future<void> _saveAppState() async {
    await DatabaseHelper().insertOrUpdateTunerWidget(initialFrequency);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Note>>(
      future: loadNotes(widget.selectedInstrument),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading notes: ${snapshot.error}',
              style: TextStyle(
                color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
              ),
            ),
          );
        }

        // Get the list of notes once it's loaded
        List<Note> notes = snapshot.data ?? [];

        for(Note note in notes){
          note.freq = calculateFrequency(note.freq);
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {

            double availableHeight = constraints.maxHeight;
            double baseFontSize = availableHeight * 0.05;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // const SizedBox(height: 5),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight * 0.1,
                          ),
                          child: ValueListenableBuilder<double>(
                            valueListenable: BluetoothConnectorWidget.frequencyNotifier,
                            builder: (context, frequency, child) {
                              return Text(
                                frequency.toStringAsFixed(1),
                                style: TextStyle(
                                  color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                                  fontSize: baseFontSize,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                          ),
                          child: ValueListenableBuilder<String>(
                            valueListenable: TunerWidget.blockedNoteNotifier,
                            builder: (context, blockedNote, child) {
                              return ValueListenableBuilder<double>(
                                valueListenable: BluetoothConnectorWidget.frequencyNotifier,
                                builder: (context, frequency, child) {
                                  String noteToDisplay = '';


                                  if (blockedNote.isNotEmpty) {
                                    noteToDisplay = blockedNote;
                                  } else {
                                    Note currentNote = checkNote(notes, frequency);
                                    textUnderNote = setTextUnderNote(currentNote, frequency);

                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      TunerWidget.currentNoteNotifier.value = currentNote.name;
                                    });


                                    noteToDisplay = currentNote.name;
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      NoteRepresentationWidget(
                                        noteString: noteToDisplay,
                                        fontSize: baseFontSize * 2,
                                      ),
                                      Text(
                                        textUnderNote,
                                        style: TextStyle(
                                          color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                                          fontSize: baseFontSize * 0.8,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: SettingsPage.isReset,
                        builder: (context, isReset, child) {
                          if(isReset){
                            initialFrequency = 440.0;
                            SettingsPage.isReset.value = false;
                          }

                          return Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight,
                              ),
                              child: FrequencyButtonWidget(
                                initialFrequency: initialFrequency,
                                fontSize: baseFontSize,
                                onFrequencyChanged: (newFrequency) {
                                  if(mounted) {
                                    setState(() {
                                      initialFrequency = newFrequency;
                                      _saveAppState();
                                    });
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<String>(
                    valueListenable: TunerWidget.blockedNoteNotifier,
                    builder: (context, blockedNote, child) {
                      return ValueListenableBuilder<double>(
                        valueListenable: BluetoothConnectorWidget.frequencyNotifier,
                        builder: (context, frequency, child) {
                          Note currentNote;
                          if (blockedNote.isNotEmpty) {
                            currentNote = notes.firstWhere((note) => note.name == blockedNote);
                          } else {
                            currentNote = getCurrentNoteBasedOnFrequency(frequency, notes);
                          }

                          double minFrequency = getPreviousNoteMidpoint(currentNote, notes);
                          double maxFrequency = getNextNoteMidpoint(currentNote, notes);
                          double tarFrequency = currentNote.freq;

                          double normalizedFrequency = mapFrequencyToGaugeRange(
                            frequency,
                            minFrequency,
                            tarFrequency,
                            maxFrequency,
                            -50,
                            50,
                          );
                          return FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Column(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth,
                                  ),
                                  child: SfLinearGauge(
                                    minimum: -50,
                                    maximum: 50,
                                    interval: 10,
                                    minorTicksPerInterval: 3,
                                    showTicks: true,
                                    showLabels: false,
                                    majorTickStyle: LinearTickStyle(
                                      length: 80,
                                      color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                                      thickness: 2,
                                    ),
                                    minorTickStyle: LinearTickStyle(
                                      length: 30,
                                      color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                                      thickness: 1,
                                    ),
                                    tickPosition: LinearElementPosition.cross,
                                    ranges: [
                                      LinearGaugeRange(
                                        startValue: -1,
                                        endValue: 1,
                                        color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                                        startWidth: 120,
                                        endWidth: 120,
                                        position: LinearElementPosition.cross,
                                      ),
                                    ],
                                    markerPointers: [
                                      LinearShapePointer(
                                        shapeType: LinearShapePointerType.rectangle,
                                        value: normalizedFrequency,
                                        width: 2,
                                        height: 160,
                                        color: const Color(0xFFAA1717),
                                        position: LinearElementPosition.cross,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth,
                                  ),
                                  child: Row(

                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Spacer(),
                                      Text(
                                        minFrequency == 0
                                            ? ' '
                                            : '${currentNote.freq.toStringAsFixed(1)} Hz',
                                        style: TextStyle(
                                          color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                                          fontSize: baseFontSize * 0.95,  // Smaller font for the range
                                        ),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.03),
              ],
            );
          },
        );
      },
    );
  }

  double mapFrequencyToGaugeRange(
    double frequency, double minFreq, double targetFreq, double maxFreq, double gaugeMin, double gaugeMax) {
    const double tolerance = 0.05;

    if (frequency == 0) {
      return gaugeMin;
    }

    if ((frequency - targetFreq).abs() <= tolerance) {
      return 0.0;
    }

    if (frequency < targetFreq) {
      return ((frequency - minFreq) / (targetFreq - minFreq)) * (0 - gaugeMin) + gaugeMin;
    } else {
      return ((frequency - targetFreq) / (maxFreq - targetFreq)) * (gaugeMax - 0);
    }
  }

  String setTextUnderNote(Note note, double frequency) {
    String text = '';
    double threshold = 0.1;
    if (note.freq < (frequency - threshold)) {
      text = 'Lower';
    } else if (note.freq > frequency + threshold) {
      text = 'Higher';
    } else if (frequency == 0) {
      text = 'No signal';
    } else {
      text = 'Perfect';
    }
    return text;
  }

  double calculateFrequency(double frequency) {
    return frequency * initialFrequency/440.0;
  }
}
