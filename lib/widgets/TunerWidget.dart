import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'BluetoothConnectorWidget.dart';
import 'package:music_tuner/models/noteModel.dart';

import 'NoteRepresentationWidget.dart';

class TunerWidget extends StatefulWidget {
  const TunerWidget({super.key, required this.title});
  final String title;

  @override
  State<TunerWidget> createState() => _TunerWidgetState();
}

class _TunerWidgetState extends State<TunerWidget> {
  String frequencyText = '0.0';
  static Future<List<Note>> notesFuture = loadNotes();
  String currentNote = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Note>>(
      future: notesFuture,
      builder: (context, snapshot) {
        // Check if data is still loading
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

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 100,
                  child: ValueListenableBuilder<double>(
                    valueListenable: BluetoothConnectorWidget.frequencyNotifier,
                    builder: (context, frequency, child) {
                      return Text(
                        frequency.toStringAsFixed(1),
                        style: TextStyle(
                          color: ThemeManager().currentTheme.colorScheme.secondary,
                          fontSize: 20,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: ValueListenableBuilder<double>(
                    valueListenable: BluetoothConnectorWidget.frequencyNotifier,
                    builder: (context, frequency, child) {
                      Note currentNote = checkNote(notes, frequency);
                      String textUnderNote = setTextUnderNote(currentNote, frequency);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // NoteRepresentationWidget(noteString: "C#2", fontSize: 40),
                          NoteRepresentationWidget(noteString: currentNote.name, fontSize: 40),
                          Text(
                            textUnderNote,
                            style: TextStyle(
                              color: ThemeManager().currentTheme.colorScheme.secondary,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 100,
                  child: Text(
                    '440 Hz',
                    style: TextStyle(
                      color: ThemeManager().currentTheme.colorScheme.secondary,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<double>(
              valueListenable: BluetoothConnectorWidget.frequencyNotifier,
              builder: (context, frequency, child) {
                // Assume you have a function to get the current note and its range
                Note currentNote = getCurrentNoteBasedOnFrequency(frequency, notes);
                double minFrequency = getPreviousNoteMidpoint(currentNote, notes);
                double maxFrequency = getNextNoteMidpoint(currentNote, notes);

                // Map the current frequency to the gauge range of -50 to 50
                double normalizedFrequency = mapFrequencyToGaugeRange(
                  frequency,
                  minFrequency,
                  maxFrequency,
                  -50,
                  50,
                );

                return SfLinearGauge(
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
                      // Small value to make it look like a tick
                      color: ThemeManager().currentTheme.colorScheme.secondary,
                      startWidth: 120,
                      // Adjust these values to change the size of the "tick"
                      endWidth: 120,
                      position: LinearElementPosition.cross,
                    ),
                  ],
                  markerPointers: [
                    LinearShapePointer(
                      shapeType: LinearShapePointerType.rectangle,
                      value: normalizedFrequency, // Bind this to the normalized frequency
                      width: 2,
                      height: 160,
                      color: const Color(0xFFAA1717),
                      position: LinearElementPosition.cross,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   gaugeValue.dispose();
  //   super.dispose();
  // }

  double mapFrequencyToGaugeRange(
      double frequency, double minFreq, double maxFreq, double gaugeMin, double gaugeMax) {
    return ((frequency - minFreq) / (maxFreq - minFreq)) * (gaugeMax - gaugeMin) + gaugeMin;
  }

  String setTextUnderNote(Note note, double frequency){
    String text = '';
    double Treshold = 0.1;
    if(note.freq < (frequency - Treshold)){
      text = 'Lower';
    }
    else if(note.freq > frequency + Treshold){
      text = 'Higher';
    }
    else{
      text = 'Perfect';
    }
    return text;
  }

}

