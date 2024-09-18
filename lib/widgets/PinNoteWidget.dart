import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/NoteRepresentationWidget.dart';

import 'NoteSrollerWidget.dart';
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
            _showNotePicker(context);
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

  void _showNotePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 300, // Adjust height for the picker
          child: Column(
            children: [
              const Text(
                'Select Note, Chromatic, and Octave',
                style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'
                ),
              ),
              Expanded(
                child: NoteScrollerWidget(),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the modal after selection
                },
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
            ],
          ),
        );
      },
    );
  }
}
