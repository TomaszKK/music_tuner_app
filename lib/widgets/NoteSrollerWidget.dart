import 'package:flutter/material.dart';
import 'package:wheel_picker/wheel_picker.dart';

class NoteScrollerWidget extends StatelessWidget {
  NoteScrollerWidget({super.key});

  final List<String> notes = [
    'C', 'D', 'E', 'F', 'G', 'A', 'B'
  ];

  final List<String> chromatics = [
    '♭', '♯', ' '
  ];

  final List<String> octaves = [
    '0', '1', '2', '3', '4', '5', '6', '7', '8'
  ];

  String note = '';
  String octave = '';
  String chromatic = '';

  void parseNoteString(String noteString){
    if(noteString == '-'){
      note = "-";
      return;
    }
    if(noteString.substring(0, 1) != '') {
      note = noteString.substring(0, 1);
    }

    if(noteString.substring(1, 2) != ''){
      if(noteString.substring(1, 2) == '♯' || noteString.substring(1, 2) == '♭'){
        chromatic = noteString.substring(1, 2);
      }
      else{
        octave = noteString.substring(1, 2);
      }
    }

    if(noteString.substring(2) != ''){
      octave = noteString.substring(2);
    }
  }

  Future<String?> showNotePicker(BuildContext context, String currentNote) async {
    parseNoteString(currentNote);

    int noteIndex = notes.indexWhere((n) => n == note);
    int chromaticIndex = chromatics.indexWhere((c) => c == chromatic);
    int octaveIndex = octaves.indexWhere((o) => o == octave);

    noteIndex = noteIndex != -1 ? noteIndex : 0;
    chromaticIndex = chromaticIndex != -1 ? chromaticIndex : 2; // Natural note by default
    octaveIndex = octaveIndex != -1 ? octaveIndex : 0;
    String? returnNote = 'C1';

    returnNote = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(15),
          constraints: const BoxConstraints(
            maxHeight: 350,
          ),
          child: Column(
            children: [
              Expanded(
                child: buildPickerContent(context, noteIndex, chromaticIndex, octaveIndex),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.red,
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      returnNote = note + chromatic + octave;
                      Navigator.of(context).pop(returnNote);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.green,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Spacer()
                ]
              )
            ],
          ),
        );
      },
    );

    return returnNote;
  }

  Widget buildPickerContent(BuildContext context, int noteIndex, int chromaticIndex, int octaveIndex) {
    final notesWheel = WheelPickerController(initialIndex: noteIndex, itemCount: notes.length);
    final chromaticsWheel = WheelPickerController(initialIndex: chromaticIndex, itemCount: chromatics.length);
    final octavesWheel = WheelPickerController(initialIndex: octaveIndex, itemCount: octaves.length);

    const heading2TextStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
      color: Colors.white,
    );
    const wheelTextStyle = TextStyle(
        fontFamily: 'Poppins',
        fontSize: 30.0,
        height: 1.5
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Notes Wheel
        Expanded(
          child: Column(
            children: [
              const Text(
                'Note',
                style: heading2TextStyle,
              ),
              Expanded(
                child: WheelPicker(
                  builder: (context, index) => Text(
                    notes[index],
                    style: wheelTextStyle,
                  ),
                  controller: notesWheel,
                  onIndexChanged: (index) {
                    note = notes[index];
                  },
                  style: WheelPickerStyle(
                    itemExtent: wheelTextStyle.fontSize! * wheelTextStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Chromatics Wheel
        Expanded(
          child: Column(
            children: [
              const Text(
                'Octave',
                style: heading2TextStyle,
              ),
              Expanded(
                child: WheelPicker(
                  builder: (context, index) => Text(
                    octaves[index],
                    style: wheelTextStyle,
                  ),
                  controller: octavesWheel,
                  onIndexChanged: (index) {
                    octave = octaves[index];
                  },
                  style: WheelPickerStyle(
                    itemExtent: wheelTextStyle.fontSize! * wheelTextStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Text(
                'Chromatic',
                style: heading2TextStyle,
              ),
              Expanded(
                child: WheelPicker(
                  builder: (context, index) => Text(
                    chromatics[index],
                    style: wheelTextStyle,
                  ),
                  controller: chromaticsWheel,
                  onIndexChanged: (index) {
                    chromatic = chromatics[index];
                  },
                  style: WheelPickerStyle(
                    itemExtent: wheelTextStyle.fontSize! * wheelTextStyle.height!, // Text height
                    squeeze: 1.25,
                    diameterRatio: .8,
                    surroundingOpacity: .25,
                    magnification: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(); // Empty widget as this is not meant to be rendered directly
  }
}
