import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/PinNoteWidget.dart';

class GuitarWidget extends StatefulWidget {
  const GuitarWidget({super.key, required this.title});

  final String title;

  @override
  State<GuitarWidget> createState() => _GuitarWidgetState();
}

class _GuitarWidgetState extends State<GuitarWidget> {
  double circleSize = 50;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imgWidth = constraints.maxHeight * 246 / 403;            //original size of the image
        double circleSpaceScale = 1;
        double topPositionScale = 1;
        double topPosition = constraints.maxHeight * 0.125;
        double imgHeight = constraints.maxHeight;
        circleSize = constraints.maxHeight * 0.125;

        if(imgWidth + 2 * circleSize >= constraints.maxWidth){
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
                SizedBox(height: max(topPosition * topPositionScale, 0)), // Prevent negative height
                PinNoteWidget(defaultNote: 'E2', circleSize: circleSize),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(defaultNote: 'A2', circleSize: circleSize),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(defaultNote: 'D3', circleSize: circleSize),
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
                PinNoteWidget(defaultNote: 'G3', circleSize: circleSize),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(defaultNote: 'B3', circleSize: circleSize),
                SizedBox(height: max(65 * imgHeight / 1000 * circleSpaceScale, 0)),
                PinNoteWidget(defaultNote: 'E4', circleSize: circleSize),
              ],
            ),
            SizedBox(width: sidePadding),
          ],
        );
      },
    );
  }
}