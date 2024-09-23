import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/widgets/PinNoteWidget.dart';

class TenorhornWidget extends StatefulWidget {
  const TenorhornWidget({super.key, required this.title});

  final String title;

  @override
  State<TenorhornWidget> createState() => _TenorhornWidgetState();
}

class _TenorhornWidgetState extends State<TenorhornWidget> {
  double circleSize = 50;

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
                  'lib/assets/Tenorhorn.svg',
                  fit: BoxFit.fitHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
            ),
            PinNoteWidget(defaultNote: 'B3', circleSize: circleSize),
            SizedBox(width: sidePadding),
          ],
        );
      },
    );
  }
}