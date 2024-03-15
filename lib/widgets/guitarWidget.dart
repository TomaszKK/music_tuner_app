import 'package:flutter/material.dart';

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
    return Container(
      // Ensure the container fills the entire screen
      width: double.infinity,
      height: double.infinity,
      // Use a Stack to layer widgets on top of each other
      child: Stack(
        children: [
          // First, add the image as the background
          Image.asset(
            'lib/assets/guitar.png', // Replace 'assets/guitar_image.jpg' with your image path
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            left: 15, // Adjust left position as needed
            top: 55, // Adjust top position as needed
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
                      color: Color(0xFFC03BFF),
                      width: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.center,
                  height: circleSize,
                  width: circleSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFC03BFF),
                      width: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.center,
                  height: circleSize,
                  width: circleSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFC03BFF),
                      width: 3,
                    ),
                  ),
                ),

              ]
            ),
          ),
          Positioned(
            right: 15, // Adjust left position as needed
            top: 55, // Adjust top position as needed
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
                      color: Color(0xFFC03BFF),
                      width: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.center,
                  height: circleSize,
                  width: circleSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFC03BFF),
                      width: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.center,
                  height: circleSize,
                  width: circleSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFC03BFF),
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