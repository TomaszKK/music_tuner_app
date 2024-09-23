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
      valueListenable: TunerWidget.blockedNoteNotifier, // Listen to the global blocked note
      builder: (context, blockedNote, child) {
        final isCurrentNoteBlocked = blockedNote == widget.defaultNote;

        return GestureDetector(
          onLongPress: () {
            setState(() {
              isTapped = !isTapped;

              if (isTapped) {
                // Block the current note, update the global blockedNoteNotifier
                TunerWidget.blockedNoteNotifier.value = widget.defaultNote;
              } else {
                // Unblock the note by setting the global blockedNoteNotifier to empty
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
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: widget.circleSize,
            width: widget.circleSize,
            decoration: BoxDecoration(
              color: isCurrentNoteBlocked ? themeColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrentNoteBlocked ? currentNoteColor : themeColor,
                width: 2,
              ),
              boxShadow: isCurrentNoteBlocked
                  ? [
                BoxShadow(
                  color: themeColor,
                  blurRadius: 20.0,
                  blurStyle: BlurStyle.outer,
                ),
              ]
                  : null,
            ),
            child: NoteRepresentationWidget(
              noteString: isCurrentNoteBlocked ? widget.defaultNote : widget.defaultNote,
              fontSize: 20,
            ),
          ),
        );
      },
    );
  }
}
