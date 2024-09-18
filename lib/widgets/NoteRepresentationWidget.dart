import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';

class NoteRepresentationWidget extends StatelessWidget {
  NoteRepresentationWidget({Key? key, required this.noteString, required this.fontSize}) : super(key: key){
    parseNoteString();
  }

  final String noteString;
  final double fontSize;
  String note = '';
  String octave = '';
  String chromatic = '';

  void parseNoteString(){
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

  @override
  Widget build(BuildContext context) {
    if(note == ''){
      return Text(
        note,
        style: TextStyle(
          color: ThemeManager().currentTheme.colorScheme.secondary,
          fontSize: fontSize,
          fontWeight: FontWeight.bold
        ),
      );
    }
    return FittedBox(
      fit: BoxFit.fill,
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            note,
            style: TextStyle(
              color: ThemeManager().currentTheme.colorScheme.secondary,
              fontSize: fontSize,
              fontWeight: FontWeight.bold
            ),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  chromatic,
                  style: TextStyle(
                    color: ThemeManager().currentTheme.colorScheme.secondary,
                    fontSize: fontSize * 0.6,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  octave,
                  style: TextStyle(
                    color: ThemeManager().currentTheme.colorScheme.secondary,
                    fontSize: fontSize * 0.6,
                    fontWeight: FontWeight.bold
                  ),
                )
              ]
          )
        ],
      )
    );
  }
}