import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'BluetoothConnectorWidget.dart';
import 'package:music_tuner/models/noteModel.dart';

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
                color: ThemeManager().currentTheme.colorScheme.secondary,
              ),
            ),
          );
        }

        // Get the list of notes once it's loaded
        List<Note> notes = snapshot.data ?? [];

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {

            double availableHeight = constraints.maxHeight;
            double availableWidth = constraints.maxWidth;

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
                                  color: ThemeManager().currentTheme.colorScheme.secondary,
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
                                          color: ThemeManager().currentTheme.colorScheme.secondary,
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
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          constraints: BoxConstraints(
                            maxHeight: constraints.maxHeight,
                          ),
                          child: Text(
                            '440 Hz',
                            style: TextStyle(
                              color: ThemeManager().currentTheme.colorScheme.secondary,
                              fontSize: baseFontSize,
                            ),
                          ),
                        ),
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

                          double normalizedFrequency = mapFrequencyToGaugeRange(
                            frequency,
                            minFrequency,
                            maxFrequency,
                            -50,
                            50,
                          );

                          return FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              constraints: BoxConstraints(
                                //maxHeight: constraints.maxHeight,
                                maxWidth: constraints.maxWidth,
                              ),
                              // padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SfLinearGauge(
                                minimum: -50,
                                maximum: 50,
                                interval: 10,
                                minorTicksPerInterval: 3,
                                showTicks: true,
                                showLabels: false,
                                majorTickStyle: LinearTickStyle(
                                  length: 80,
                                  color: ThemeManager().currentTheme.colorScheme.secondary,
                                  thickness: 2,
                                ),
                                minorTickStyle: LinearTickStyle(
                                  length: 30,
                                  color: ThemeManager().currentTheme.colorScheme.secondary,
                                  thickness: 1,
                                ),
                                tickPosition: LinearElementPosition.cross,
                                ranges: [
                                  LinearGaugeRange(
                                    startValue: -0.5,
                                    endValue: 0.5,
                                    color: ThemeManager().currentTheme.colorScheme.secondary,
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
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.05),
              ],
            );
          },
        );
      },
    );
  }

  double mapFrequencyToGaugeRange(
      double frequency, double minFreq, double maxFreq, double gaugeMin, double gaugeMax) {
    return ((frequency - minFreq) / (maxFreq - minFreq)) * (gaugeMax - gaugeMin) + gaugeMin;
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
}
