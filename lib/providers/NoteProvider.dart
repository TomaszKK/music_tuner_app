import 'package:music_tuner/assets/notes.dart';
import 'package:music_tuner/assets/notes_saxophone.dart';
import 'package:music_tuner/assets/notes_tenor.dart';
import '../assets/notes_trumpet.dart';

class NoteProvider {
  Map<String, double> standardNotes = standard_notes;
  Map<String, double> saxophoneNotes = saxophone_notes;
  Map<String, double> trumpetNotes = trumpet_notes;
  Map<String, double> tenorhornNotes = tenorhorn_notes;

  Map<String, double> getNotes(String instrument) {
    switch (instrument) {
      case 'Guitar':
      case 'Bass':
        return standardNotes;
      case 'Saxophone':
        return saxophoneNotes;
      case 'Trumpet':
        return trumpetNotes;
      case 'Tenorhorn':
        return tenorhornNotes;
      default:
        return standardNotes;
    }
  }
}