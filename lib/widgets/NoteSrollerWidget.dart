import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

class NoteScrollerWidget extends StatelessWidget {
  NoteScrollerWidget({super.key});

  final List<String> notes = [
    'C', 'D', 'E', 'F', 'G', 'A', 'B'
  ];

  final List<String> chromatics = [
    '♭', '♯', '' // Add empty string for natural notes
  ];

  final List<String> octaves = [
    '1', '2', '3', '4', '5', '6', '7', '8'
  ];

  @override
  Widget build(BuildContext context) {
    final notesWheel = WheelPickerController(itemCount: notes.length);
    final chromaticsWheel = WheelPickerController(itemCount: chromatics.length);
    final octavesWheel = WheelPickerController(itemCount: octaves.length);

    const textStyle = TextStyle(fontSize: 32.0, height: 1.5);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Notes Wheel
        Expanded(
          child: WheelPicker(
            builder: (context, index) => Text(
              notes[index],
              style: textStyle,
            ),
            controller: notesWheel,
            onIndexChanged: (index) {
              print("Selected Note: ${notes[index]}");
            },
            style: WheelPickerStyle(
              itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
              squeeze: 1.25,
              diameterRatio: .8,
              surroundingOpacity: .25,
              magnification: 1.2,
            ),
          ),
        ),

        // Chromatics Wheel
        Expanded(
          child: WheelPicker(
            builder: (context, index) => Text(
              chromatics[index],
              style: textStyle,
            ),
            controller: chromaticsWheel,
            onIndexChanged: (index) {
              print("Selected Chromatic: ${chromatics[index]}");
            },
            style: WheelPickerStyle(
              itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
              squeeze: 1.25,
              diameterRatio: .8,
              surroundingOpacity: .25,
              magnification: 1.2,
            ),
          ),
        ),

        // Octaves Wheel
        Expanded(
          child: WheelPicker(
            builder: (context, index) => Text(
              octaves[index],
              style: textStyle,
            ),
            controller: octavesWheel,
            onIndexChanged: (index) {
              print("Selected Octave: ${octaves[index]}");
            },
            style: WheelPickerStyle(
              itemExtent: textStyle.fontSize! * textStyle.height!, // Text height
              squeeze: 1.25,
              diameterRatio: .8,
              surroundingOpacity: .25,
              magnification: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
