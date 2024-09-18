import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/NoteRepresentationWidget.dart';

import 'NoteSrollerWidget.dart';
import 'TunerWidget.dart';

class PinNoteWidget extends StatefulWidget {
  PinNoteWidget({
    Key? key,
    required this.defaultNote,
    required this.circleSize,
  }) : super(key: key);

  String defaultNote;
  final double circleSize;

  @override
  State<PinNoteWidget> createState() => _PinNoteWidgetState();
}

class _PinNoteWidgetState extends State<PinNoteWidget> {
  bool isTapped = false; // State to track if the widget is tapped

  @override
  Widget build(BuildContext context) {
    final themeColor = ThemeManager().currentTheme.colorScheme.secondaryContainer;
    final currentNoteColor = ThemeManager().currentTheme.colorScheme.onSecondaryContainer;
    final NoteScrollerWidget noteScrollerWidget = NoteScrollerWidget();

    return ValueListenableBuilder<String>(
      valueListenable: TunerWidget.currentNoteNotifier, // Listen to the ValueNotifier
      builder: (context, currentNote, child) {
        final isCurrentNote = currentNote == widget.defaultNote;

        return GestureDetector(
          onLongPress: () {
            setState(() {
              isTapped = !isTapped;

              if (isTapped) {
                // Block the current note in TunerWidget by updating the blockedNoteNotifier
                TunerWidget.blockedNoteNotifier.value = widget.defaultNote;
              } else {
                // Unblock the note if tapped again
                TunerWidget.blockedNoteNotifier.value = '';
              }
            });
          },
          onTap: () async {
            // Show note picker and wait for the selected note
            String? returnNote = await noteScrollerWidget.showNotePicker(context, widget.defaultNote);

            if (returnNote != null) {
              setState(() {
                widget.defaultNote = returnNote;
                if(isTapped){
                  // Unblock the note if it was blocked
                  TunerWidget.blockedNoteNotifier.value = widget.defaultNote;
                }
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: widget.circleSize,
            width: widget.circleSize,
            decoration: BoxDecoration(
              color: isTapped ? themeColor : Colors.transparent, // Fill with red if tapped
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentNote ? currentNoteColor : themeColor,
                width: 2,
              ),
              boxShadow: isCurrentNote
                  ? [
                BoxShadow(
                  color: themeColor,
                  blurRadius: 20.0,
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
