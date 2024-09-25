import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';

import '../PinNoteWidget.dart';

class BassWidget extends StatefulWidget {
  BassWidget({super.key, required this.title, required this.noteList});

  final String title;
  List<String> noteList;

  @override
  State<BassWidget> createState() => _BassWidgetState();
}

class _BassWidgetState extends State<BassWidget> {
  double circleSize = 50;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imgWidth = constraints.maxHeight * 225 / 402;            //original size of the image
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
                  PinNoteWidget(defaultNote: widget.noteList[0], circleSize: circleSize, currentInstrument: 'Bass'),
                  SizedBox(height: circleSpaceScale),
                  PinNoteWidget(defaultNote: widget.noteList[1], circleSize: circleSize, currentInstrument: 'Bass'),
                  SizedBox(height: circleSpaceScale),
                  PinNoteWidget(defaultNote: widget.noteList[2], circleSize: circleSize, currentInstrument: 'Bass'),
                  SizedBox(height: circleSpaceScale),
                  PinNoteWidget(defaultNote: widget.noteList[3], circleSize: circleSize, currentInstrument: 'Bass'),
                ]
            ),
            Expanded(
              child: SizedBox(
                height: imgHeight,
                child: SvgPicture.asset(
                  'lib/assets/Bass.svg',
                  fit: BoxFit.fitHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
            ),
            SizedBox(width: circleSize + (constraints.maxWidth - imgWidth - 2 * circleSize) / 2 * 0.8),
          ],
        );
      },
    );
  }

  Widget _buildCircle(){
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
    );
  }
}