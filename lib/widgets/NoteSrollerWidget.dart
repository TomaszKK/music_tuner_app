import 'package:flutter/material.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';
import 'package:wheel_picker/wheel_picker.dart';

class NoteScrollerWidget extends StatelessWidget {
  NoteScrollerWidget({super.key});

  final List<String> notes = [];

  final List<String> chromatics = [];

  final List<String> octaves = [];

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

  void setRanges() {
    // Extract unique note letters (C, D, E, F, G, A, B)
    final Set<String> notesSet = {};
    final Set<String> chromaticsSet = {' '}; // Adding empty space for no chromatic symbol
    final Set<String> octavesSet = {};

    // Loop over the noteFrequencyMap to extract the note components
    for (String noteString in selectedInstrumentNotesMap.keys) {
      // Skip if it's the dash "-"
      if (noteString == "-") continue;

      // Extract the note letter (C, D, E, F, G, A, B)
      final note = noteString[0]; // First character is the note
      notesSet.add(note);

      // Extract the chromatic (♯, ♭, or nothing)
      if (noteString.length > 2) {
        final chromatic = noteString[1];
        if (chromatic == '♯' || chromatic == '♭') {
          chromaticsSet.add(chromatic);
        }
      }

      // Extract the octave number
      final octave = noteString.substring(noteString.length - 1); // Last character is the octave
      octavesSet.add(octave);
    }

    // Convert sets to lists and sort them
    notes
      ..clear()
      ..addAll(notesSet);
    chromatics
      ..clear()
      ..addAll(chromaticsSet);
    octaves
      ..clear()
      ..addAll(octavesSet);

    // Sort the lists in order
    notes.sort(); // Already in natural order C, D, E, F, G, A, B
    chromatics.sort(); // Order: ' ', ♭, ♯
    octaves.sort(); // Octaves in numeric order
  }

  Future<String?> showNotePicker(BuildContext context, String currentNote, String defaultNote) async {
    setRanges();
    parseNoteString(currentNote);

    int noteIndex = notes.indexWhere((n) => n == note);
    int chromaticIndex = chromatics.indexWhere((c) => c == chromatic);
    int octaveIndex = octaves.indexWhere((o) => o == octave);

    noteIndex = noteIndex != -1 ? noteIndex : 0;
    chromaticIndex = chromaticIndex != -1 ? chromaticIndex : 2;
    octaveIndex = octaveIndex != -1 ? octaveIndex : 0;
    String? returnNote = '';

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
                      parseNoteString(defaultNote);
                      Navigator.of(context).pop(defaultNote);
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
                    itemExtent: wheelTextStyle.fontSize! * wheelTextStyle.height!,
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
                    itemExtent: wheelTextStyle.fontSize! * wheelTextStyle.height!,
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
                    itemExtent: wheelTextStyle.fontSize! * wheelTextStyle.height!,
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
    return Container();
  }
}
