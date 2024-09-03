import 'dart:convert';  // For JSON decoding
import 'dart:io';      // For reading files
import 'package:flutter/services.dart' show rootBundle;

// Note class to hold name and frequency
class Note {
  final String name;
  final double freq;

  const Note({
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
Future<List<Note>> loadNotes() async {
  try {
    // Load the JSON file from assets
    final String fileContents = await rootBundle.loadString('lib/assets/notes.json');

    // Decode JSON into a Map
    final Map<String, dynamic> jsonMap = jsonDecode(fileContents);

    // Convert the map entries into a list of Note objects
    return jsonMap.entries
        .map((entry) => Note.fromJson(entry))
        .toList(growable: false);
  } catch (e) {
    print('Error reading or parsing the file: $e');
    return [];
  }
}

String checkNote(List<Note> notes, double freq) {
  if (notes.isEmpty) {
    return '';
  }

  // Sort the notes by frequency to ensure correct comparisons
  notes.sort((a, b) => a.freq.compareTo(b.freq));

  // Edge cases: frequency is lower than the lowest note or higher than the highest note
  if (freq <= notes.first.freq) {
    return notes.first.name;
  }
  if (freq >= notes.last.freq) {
    return notes.last.name;
  }

  // Iterate over the notes to find the closest one
  for (int i = 0; i < notes.length - 1; i++) {
    final Note currentNote = notes[i];
    final Note nextNote = notes[i + 1];

    // Calculate the midpoint between the current note and the next note
    final double midpoint = (currentNote.freq + nextNote.freq) / 2;

    // Check if the frequency is closer to the current note or the next note
    if (freq < midpoint) {
      return currentNote.name;
    }
  }

  // If no match found, return the last note (though this should not occur due to edge handling)
  return notes.last.name;
}
