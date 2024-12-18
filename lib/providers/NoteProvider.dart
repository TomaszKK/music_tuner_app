import 'package:music_tuner/assets/Notes_Freq/notes.dart';
import 'package:music_tuner/assets/Notes_Freq/notes_saxophone.dart';
import 'package:music_tuner/assets/Notes_Freq/notes_tenor.dart';
import '../assets/Notes_Freq/notes_trumpet.dart';

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