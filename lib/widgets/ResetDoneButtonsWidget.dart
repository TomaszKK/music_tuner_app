import 'package:flutter/material.dart';

class ResetDoneButtons extends StatelessWidget {
  final VoidCallback onReset;
  final VoidCallback onDone;
  final Color resetColor;
  final Color doneColor;

  const ResetDoneButtons({
    Key? key,
    required this.onReset,
    required this.onDone,
    required this.resetColor,
    required this.doneColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: onReset,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: resetColor.withOpacity(0.5),
          ),
          child: Text(
            'Reset',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: resetColor,
            ),
          ),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: onDone,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: doneColor.withOpacity(0.5),
          ),
          child: Text(
            'Done',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: doneColor,
            ),
          ),
        ),
      ],
    );
  }
}
