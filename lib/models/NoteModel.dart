import 'dart:convert';  // For JSON decoding
import 'package:flutter/services.dart' show rootBundle;
import 'package:music_tuner/providers/NoteProvider.dart';

import '../providers/noteInstrumentProvider.dart';

// Note class to hold name and frequency
class Note {
  final String name;
  double freq;

  Note({
    required this.name,
    required this.freq,
  });

  String getName() {
    return name;
  }

  double getFreq() {
    return freq;
  }

  // Factory method to create a Note from a JSON map entry
  factory Note.fromJson(MapEntry<String, dynamic> entry) {
    return Note(
      name: entry.key,
      freq: (entry.value as num).toDouble(),
    );
  }

  @override
  String toString() {
    return 'Note: $name, Frequency: $freq Hz';
  }
}

// Function to read JSON file and parse it into a list of Note objects
Future<List<Note>> loadNotes(String selectedInstrument) async {
  try {
      final Map<String, dynamic> map = NoteProvider().getNotes(selectedInstrument);

    return map.entries
        .map((entry) => Note.fromJson(entry))
        .toList(growable: false);
  } catch (e) {
    return [];
  }
}

Note checkNote(List<Note> notes, double freq) {
  if(freq == 0){
    return notes[0];
  }
   // Sort the notes by frequency to ensure correct comparisons
  notes.sort((a, b) => a.freq.compareTo(b.freq));

  // Edge cases: frequency is lower than the lowest note or higher than the highest note
  if (freq <= notes.first.freq) {
    return notes.first;
  }
  if (freq >= notes.last.freq) {
    return notes.last;
  }

  // Iterate over the notes to find the closest one
  for (int i = 0; i < notes.length - 1; i++) {
    final Note currentNote = notes[i];
    final Note nextNote = notes[i + 1];

    // Calculate the midpoint between the current note and the next note
    final double midpoint = (currentNote.freq + nextNote.freq) / 2;

    // Check if the frequency is closer to the current note or the next note
    if (freq < midpoint) {
      return currentNote;
    }
  }

  // If no match found, return the last note (though this should not occur due to edge handling)
  return notes.last;
}


Note getCurrentNoteBasedOnFrequency(double frequency, List<Note> notes) {
  return notes.reduce((a, b) => (frequency - a.freq).abs() < (frequency - b.freq).abs() ? a : b);
}

double getPreviousNoteMidpoint(Note currentNote, List<Note> notes) {
  int index = notes.indexOf(currentNote);
  if (index > 0) {
    Note previousNote = notes[index - 1];
    return (currentNote.freq + previousNote.freq) / 2;
  } else {
    // If there's no previous note, you might return a default value or handle it accordingly
    return currentNote.freq; // Return the current note's frequency as a fallback
  }
}

double getNextNoteMidpoint(Note currentNote, List<Note> notes) {
  int index = notes.indexOf(currentNote);
  if (index < notes.length - 1) {
    Note nextNote = notes[index + 1];
    return (currentNote.freq + nextNote.freq) / 2;
  } else {
    // If there's no next note, you might return a default value or handle it accordingly
    return currentNote.freq; // Return the current note's frequency as a fallback
  }
}