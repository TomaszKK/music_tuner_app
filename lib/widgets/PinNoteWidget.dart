import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/NoteRepresentationWidget.dart';

import 'TunerWidget.dart';

class PinNoteWidget extends StatefulWidget {
  const PinNoteWidget({
    Key? key,
    required this.defaultNote,
    required this.circleSize,
  }) : super(key: key);

  final String defaultNote;
  final double circleSize;

  @override
  State<PinNoteWidget> createState() => _PinNoteWidgetState();
}

class _PinNoteWidgetState extends State<PinNoteWidget> {
  bool isTapped = false; // State to track if the widget is tapped

  @override
  Widget build(BuildContext context) {
    final themeColor = ThemeManager().currentTheme.colorScheme.secondaryContainer;

    return ValueListenableBuilder<String>(
      valueListenable: TunerWidget.currentNoteNotifier, // Listen to the ValueNotifier
      builder: (context, currentNote, child) {
        final isCurrentNote = currentNote == widget.defaultNote;

        return GestureDetector(
          onLongPress: () {
            setState(() {
              isTapped = !isTapped; // Toggle the tapped state
            });
          },
          onTap: () {

          },
          child: Container(
            alignment: Alignment.center,
            height: widget.circleSize,
            width: widget.circleSize,
            decoration: BoxDecoration(
              color: isTapped ? themeColor : Colors.transparent, // Fill with red if tapped
              shape: BoxShape.circle,
              border: Border.all(
                color: themeColor,
                width: 2,
              ),
              boxShadow: isCurrentNote
                  ? [
                BoxShadow(
                  color: themeColor,
                  blurRadius: 15.0,
                  blurStyle: BlurStyle.outer,
                ),
              ]
                  : null, // Only add boxShadow if it's the current note
            ),
            child: NoteRepresentationWidget(
              noteString: isCurrentNote ? currentNote : widget.defaultNote,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}
