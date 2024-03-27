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
  double topCirclePosition = 55;
  double rightCirclePosition = 15;
  double leftCirclePosition = 15;
  double betweenCircleSpacing = 25;
  double oldBoxHeight = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double currentBoxWidth = constraints.maxWidth;
        double currentBoxHeight = constraints.maxHeight;

        return SizedBox(
          width: currentBoxWidth,
          height: currentBoxHeight,
          child: Stack(
            children: [
              Positioned(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: SvgPicture.asset(
                  'lib/assets/Guitar.svg',
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
              Positioned(
                left: leftCirclePosition,
                top: topCirclePosition,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildCircle(),
                    SizedBox(height: betweenCircleSpacing),
                    _buildCircle(),
                    SizedBox(height: betweenCircleSpacing),
                    _buildCircle(),
                  ],
                ),
              ),
              Positioned(
                right: rightCirclePosition,
                top: topCirclePosition,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildCircle(),
                    SizedBox(height: betweenCircleSpacing),
                    _buildCircle(),
                    SizedBox(height: betweenCircleSpacing),
                    _buildCircle(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCircle(double currentBoxHeight, double oldBoxHeight){
    return Container(
      alignment: Alignment.center,
      height: circleSize * _updateElementSize(currentBoxHeight, );
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

  double _updateElementSize(double currentSize, double oldSize) {
    if(currentSize < oldSize){
      return currentSize/oldSize;
    }
    else if(currentSize > oldSize){
      return currentSize*oldSize;
    }
    else{
      return 1;
    }
  }
}