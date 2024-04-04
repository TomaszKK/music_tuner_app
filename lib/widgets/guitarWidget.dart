import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';

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
        double imgWidth = constraints.maxHeight * 246 / 403;
        double imgHeight = constraints.maxHeight;
        double widthPosition = imgWidth * 0.01;

        double topPosition = constraints.maxHeight * 0.125; // 20% from the top of the image

        circleSize = constraints.maxWidth * 0.125; // 50% of the image width

        print('imgWidth: $imgWidth');
        print('imgHeight: $imgHeight');
        print('leftPosition: $widthPosition');
        print('topPosition: $topPosition');

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: (constraints.maxWidth - imgWidth - 2 * circleSize) / 2 * 0.8),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: topPosition, width: circleSize),
                _buildCircle(),
                SizedBox(height: 65 * imgHeight / 1000, width: circleSize),
                _buildCircle(),
                SizedBox(height: 65 * imgHeight / 1000, width: circleSize),
                _buildCircle(),
              ]
            ),
            Expanded(
              child: SizedBox(
                height: constraints.maxHeight,
                child: SvgPicture.asset(
                  'lib/assets/Guitar.svg',
                  fit: BoxFit.fitHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
            ),
            Column(
                children: <Widget>[
                  SizedBox(height: topPosition),
                  _buildCircle(),
                  SizedBox(height: 65 * imgHeight / 1000),
                  _buildCircle(),
                  SizedBox(height: 65 * imgHeight / 1000),
                  _buildCircle(),
                ]
            ),
            SizedBox(width: (constraints.maxWidth - imgWidth - 2 * circleSize) / 2 * 0.8),
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