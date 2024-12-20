import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';
import 'package:provider/provider.dart';

import '../PinNoteWidget.dart';

class BassWidget extends StatefulWidget {
  BassWidget({super.key, required this.title, required this.noteList, required this.onNotesChanged});

  final String title;
  List<String> noteList;
  final Function(List<String>) onNotesChanged;

  @override
  State<BassWidget> createState() => _BassWidgetState();
}

class _BassWidgetState extends State<BassWidget> {
  double circleSize = 50;

  void onNoteChanged(int index, String newNote) {
    setState(() {
      widget.noteList[index] = newNote;
    });
    widget.onNotesChanged(widget.noteList);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imgWidth = constraints.maxHeight * 225 / 402;
        double topPositionScale = 1;
        double topPosition = constraints.maxHeight * 0.05;
        double imgHeight = constraints.maxHeight;
        double circleSpaceScale = 53 * imgHeight / 1000;
        circleSize = constraints.maxHeight * 0.120;

        if(imgWidth + 2 * circleSize >= constraints.maxWidth) {
          imgHeight = constraints.maxHeight * 0.9;
          circleSpaceScale = circleSpaceScale * 1.4;
          topPositionScale = 1.4;
          circleSize = circleSize * 0.6;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: (constraints.maxWidth - imgWidth - 2 * circleSize) / 2 * 0.8),
            Column(
              children: <Widget>[
                SizedBox(height: topPosition * topPositionScale),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Bass']![0],
                  currentNote: widget.noteList[0],
                  circleSize: circleSize,
                  currentInstrument: 'Bass',
                  onNoteChanged: (newNote) => onNoteChanged(0, newNote),
                ),
                SizedBox(height: circleSpaceScale),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Bass']![1],
                  currentNote: widget.noteList[1],
                  circleSize: circleSize,
                  currentInstrument: 'Bass',
                  onNoteChanged: (newNote) => onNoteChanged(1, newNote),
                ),
                SizedBox(height: circleSpaceScale),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Bass']![2],
                  currentNote: widget.noteList[2],
                  circleSize: circleSize,
                  currentInstrument: 'Bass',
                  onNoteChanged: (newNote) => onNoteChanged(2, newNote),
                ),
                SizedBox(height: circleSpaceScale),
                PinNoteWidget(
                  defaultNote: noteInstrumentDefaultProvider['Bass']![3],
                  currentNote: widget.noteList[3],
                  circleSize: circleSize,
                  currentInstrument: 'Bass',
                  onNoteChanged: (newNote) => onNoteChanged(3, newNote),
                ),
              ]
            ),
            Expanded(
              child: SizedBox(
                height: imgHeight,
                child: SvgPicture.asset(
                  'lib/assets/Bass.svg',
                  fit: BoxFit.fitHeight,
                  colorFilter: ColorFilter.mode(
                    Provider.of<ThemeManager>(context).currentTheme.colorScheme.onSecondary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            SizedBox(width: circleSize + (constraints.maxWidth - imgWidth - 2 * circleSize) / 2 * 0.8),
          ],
        );
      },
    );
  }
}