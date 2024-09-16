import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/NoteRepresentationWidget.dart';

class PinNoteWidget extends StatelessWidget {
  const PinNoteWidget({Key? key, required this.defaultNote, required this.circleSize}) : super(key: key);

  final String defaultNote;
  final double circleSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: circleSize,
      width: circleSize,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: ThemeManager().currentTheme.colorScheme.secondaryContainer,
          width: 3,
        ),
      ),
      child: NoteRepresentationWidget(noteString: defaultNote, fontSize:20),
    );
  }
}