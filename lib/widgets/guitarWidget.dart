import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'dart:async';

class GuitarWidget extends StatefulWidget {
  const GuitarWidget({super.key, required this.title});

  final String title;

  @override
  State<GuitarWidget> createState() => _GuitarWidgetState();
}

class _GuitarWidgetState extends State<GuitarWidget> {
  double circleSize = 50;
  final GlobalKey _svgKey = GlobalKey();
  double leftPosition = 0; // Add a variable to store the left position

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _calculateLeftPosition(context);
    });
  }

  void _calculateLeftPosition(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_svgKey.currentContext != null) {
        final RenderBox renderBox = _svgKey.currentContext!.findRenderObject() as RenderBox;
        double imgWidth = renderBox.size.width;
        setState(() {
          leftPosition = (MediaQuery.of(context).size.width - imgWidth) / 2 * 0.5;
        });
        print('leftPosition: $leftPosition');
        print('imgWidth: $imgWidth');
        print('MediaQuery.of(context).size.width: ${MediaQuery.of(context).size.width}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double imgHeight = constraints.maxHeight;
        double topPosition = imgHeight * 0.125;

        circleSize = 125 * imgHeight / 1000;

        // print('widthGEneral: ${constraints.maxWidth}');
        // print('imgHeight: $imgHeight');
        // print('topPosition: $topPosition');

        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                child: SvgPicture.asset(
                  'lib/assets/Guitar.svg',
                  key: _svgKey,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                left: leftPosition,
                top: topPosition,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildCircle(),
                    SizedBox(height: 65 * imgHeight / 1000),
                    _buildCircle(),
                    SizedBox(height: 65 * imgHeight / 1000),
                    _buildCircle(),
                  ],
                ),
              ),
              Positioned(
                right: leftPosition,
                top: topPosition,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildCircle(),
                    SizedBox(height: 65 * imgHeight / 1000),
                    _buildCircle(),
                    SizedBox(height: 65 * imgHeight / 1000),
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