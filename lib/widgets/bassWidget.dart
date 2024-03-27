import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';

class BassWidget extends StatefulWidget {
  const BassWidget({super.key, required this.title});

  final String title;

  @override
  State<BassWidget> createState() => _BassWidgetState();
}

class _BassWidgetState extends State<BassWidget> {
  double circleSize = 50;
  double topCirclePosition = 60;
  double rightCirclePosition = 20;
  double leftCirclePosition = 20;
  double betweenCircleSpacing = 22;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          SvgPicture.asset(
            'lib/assets/Bass.svg',
            width: double.infinity,
            height: double.infinity,
            color: ThemeManager().currentTheme.colorScheme.onSecondary,
          ),
          Positioned(
            right: rightCirclePosition,
            top: topCirclePosition,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
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
                  ),
                  SizedBox(height: betweenCircleSpacing),
                  Container(
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
                  ),
                  SizedBox(height: betweenCircleSpacing),
                  Container(
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
                  ),
                  SizedBox(height: betweenCircleSpacing),
                  Container(
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
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}