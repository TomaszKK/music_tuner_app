import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';
import 'package:music_tuner/widgets/PinNoteWidget.dart';

class SaxophoneWidget extends StatefulWidget {
  SaxophoneWidget({super.key, required this.title, required this.noteList, required this.onNotesChanged});

  final String title;
  List<String> noteList;
  final Function(List<String>) onNotesChanged;

  @override
  State<SaxophoneWidget> createState() => _SaxophoneWidgetState();
}

class _SaxophoneWidgetState extends State<SaxophoneWidget> {
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
        double imgWidth = constraints.maxHeight * 246 / 403;
        double imgHeight = constraints.maxHeight;
        circleSize = constraints.maxHeight * 0.125;

        if(imgWidth + 2 * circleSize >= constraints.maxWidth){
          imgHeight = constraints.maxHeight * 0.9;
          circleSize = circleSize * 0.8;
        }

        double sidePadding = max((constraints.maxWidth - imgWidth - circleSize) / 2 * 1, 0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: sidePadding + circleSize),
            Expanded(
              child: SizedBox(
                height: imgHeight,
                child: SvgPicture.asset(
                  'lib/assets/Saxophone.svg',
                  fit: BoxFit.fitHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
            ),
            PinNoteWidget(
              defaultNote: noteInstrumentDefaultProvider['Saxophone']![0],
              currentNote: widget.noteList[0],
              circleSize: circleSize,
              currentInstrument: 'Saxophone',
              onNoteChanged: (newNote) => onNoteChanged(0, newNote),
            ),
            SizedBox(width: sidePadding),
          ],
        );
      },
    );
  }
}