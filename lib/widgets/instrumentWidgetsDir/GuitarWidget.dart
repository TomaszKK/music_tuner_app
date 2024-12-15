import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';
import 'package:music_tuner/widgets/PinNoteWidget.dart';

class GuitarWidget extends StatefulWidget {
  GuitarWidget({super.key, required this.title, required this.noteList, required this.onNotesChanged});

  final String title;
  List<String> noteList;
  final Function(List<String>) onNotesChanged; // Callback to notify parent

  @override
  State<GuitarWidget> createState() => _GuitarWidgetState();
}


class _GuitarWidgetState extends State<GuitarWidget> {
  double circleSize = 50;

  // Callback when a note is changed
  void onNoteChanged(int index, String newNote) {
    setState(() {
      widget.noteList[index] = newNote;
    });

    // Notify parent about the updated notes
    widget.onNotesChanged(widget.noteList);
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imgWidth = constraints.maxHeight * 246 / 403;
        double circleSpaceScale = 1;
        double topPositionScale = 1;
        double topPosition = constraints.maxHeight * 0.125;
        double imgHeight = constraints.maxHeight;
        circleSize = constraints.maxHeight * 0.125;

        if (imgWidth + 2 * circleSize >= constraints.maxWidth) {
          imgHeight = constraints.maxHeight * 0.9;
          circleSpaceScale = 1.15;
          topPositionScale = 1.4;
          circleSize = circleSize * 0.8;
        }

        double sidePadding = max((constraints.maxWidth - imgWidth - 2 * circleSize) / 2 * 0.8, 0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: sidePadding),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: max(topPosition * topPositionScale, 0)),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Guitar']![0],
                  currentNote: widget.noteList[0],
                  circleSize: circleSize,
                  currentInstrument: 'Guitar',
                  onNoteChanged: (newNote) => onNoteChanged(0, newNote),
                ),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Guitar']![1],
                  currentNote: widget.noteList[1],
                  circleSize: circleSize,
                  currentInstrument: 'Guitar',
                  onNoteChanged: (newNote) => onNoteChanged(1, newNote),
                ),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Guitar']![2],
                  currentNote: widget.noteList[2],
                  circleSize: circleSize,
                  currentInstrument: 'Guitar',
                  onNoteChanged: (newNote) => onNoteChanged(2, newNote),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: imgHeight,
                child: SvgPicture.asset(
                  'lib/assets/Guitar.svg',
                  fit: BoxFit.fitHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: max(topPosition * topPositionScale, 0)),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Guitar']![3],
                  currentNote: widget.noteList[3],
                  circleSize: circleSize,
                  currentInstrument: 'Guitar',
                  onNoteChanged: (newNote) => onNoteChanged(3, newNote),
                ),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Guitar']![4],
                  currentNote: widget.noteList[4],
                  circleSize: circleSize,
                  currentInstrument: 'Guitar',
                  onNoteChanged: (newNote) => onNoteChanged(4, newNote),
                ),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Guitar']![5],
                  currentNote: widget.noteList[5],
                  circleSize: circleSize,
                  currentInstrument: 'Guitar',
                  onNoteChanged: (newNote) => onNoteChanged(5, newNote),
                ),
              ],
            ),
            SizedBox(width: sidePadding),
          ],
        );
      },
    );
  }
}
