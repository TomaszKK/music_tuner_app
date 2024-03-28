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
        double imgWidth = constraints.maxWidth;
        double imgHeight = constraints.maxHeight;
        double widthPosition = imgWidth * 0.25;

        // if(constraints.maxWidth >= 620) {
        //   leftPosition = imgWidth * 0.40;
        // }
        // else if(constraints.maxWidth >= 420 && constraints.maxWidth < 620) {
        //   leftPosition = imgWidth * 0.35;
        // }
        // else if(constraints.maxWidth >= 320 && constraints.maxWidth < 420){
        //   leftPosition = imgWidth * 0.30;
        // }
        // else if(constraints.maxWidth >= 220 && constraints.maxWidth < 320){
        //   leftPosition = imgWidth * 0.25;
        // }
        // else{
        //   leftPosition = imgWidth * 0.2;
        // }



        double topPosition = imgHeight * 0.125; // 20% from the top of the image

        circleSize = 125 * imgHeight / 1000; // 50% of the image width

        print('imgWidth: $imgWidth');
        print('imgHeight: $imgHeight');
        print('leftPosition: $widthPosition');
        print('topPosition: $topPosition');

        return SizedBox(
          // height: imgHeight,
          // width: imgWidth,
          child: Stack(
            children: [
              Positioned(
                width: imgWidth,
                height: imgHeight,
                child: SvgPicture.asset(
                  'lib/assets/Guitar.svg',
                  // width: imgWidth,
                  // height: imgHeight,
                  color: ThemeManager().currentTheme.colorScheme.onSecondary,
                ),
              ),
              Positioned(
                left: widthPosition,
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
                right: widthPosition,
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