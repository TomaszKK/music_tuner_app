import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/providers/noteInstrumentProvider.dart';
import 'package:music_tuner/widgets/PinNoteWidget.dart';

class TrumpetWidget extends StatefulWidget {
  TrumpetWidget({super.key, required this.title, required this.noteList, required this.onNotesChanged});

  final String title;
  List<String> noteList;
  final Function(List<String>) onNotesChanged;

  @override
  State<TrumpetWidget> createState() => _TrumpetWidgetState();
}

class _TrumpetWidgetState extends State<TrumpetWidget> {
  double circleSize = 50;

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
        double imgWidth = constraints.maxHeight * 364.03 / 365.38 * 0.8;
        double imgHeight = constraints.maxHeight;
        circleSize = constraints.maxHeight * 0.125;

        if(imgWidth + 2 * circleSize >= constraints.maxWidth){
          imgHeight = constraints.maxHeight * 0.9;
          circleSize = circleSize * 0.8;
        }

        double sidePadding = max((constraints.maxWidth - imgWidth - circleSize) / 2, 0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: sidePadding + circleSize),
            Expanded(
              child: SizedBox(
                height: imgHeight,
                child: SvgPicture.asset(
                  'lib/assets/Trumpet.svg',
                  fit: BoxFit.contain,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
            ),
            PinNoteWidget(
              defaultNote: noteInstrumentDefaultProvider['Trumpet']![0],
              currentNote: widget.noteList[0],
              circleSize: circleSize,
              currentInstrument: 'Trumpet',
              onNoteChanged: (newNote) => onNoteChanged(0, newNote),  // Callback for the first pin
            ),
            SizedBox(width: sidePadding),
          ],
        );
      },
    );
  }
}