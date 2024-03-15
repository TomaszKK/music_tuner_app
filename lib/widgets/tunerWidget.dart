import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TunerWidget extends StatefulWidget {
  const TunerWidget({super.key, required this.title});

  final String title;

  @override
  State<TunerWidget> createState() => _TunerWidgetState();
}

class _TunerWidgetState extends State<TunerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 100,
              child: const Text(
                'Someting',
                style: TextStyle(
                  color: Color(0xFF0AEF05),
                  fontSize: 20,
                ),
              )
            ),
            const SizedBox(width: 20),
            Container(

              alignment: Alignment.center,
              height: 100,
              width: 100,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF0AEF05),
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    'Tuned',
                    style: TextStyle(
                      color: Color(0xFF0AEF05),
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 100,
              child: const Text(
                  '440 Hz',
                  style: TextStyle(
                    color: Color(0xFF0AEF05),
                    fontSize: 20,
                  ),
                ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SfLinearGauge(
          minimum: -50,
          maximum: 50,
          interval: 10,
          minorTicksPerInterval: 3,
          showTicks: true,
          showLabels: false,
          majorTickStyle: const LinearTickStyle(length: 80, color: Color(0xFF0AEF05), thickness: 2),
          minorTickStyle: const LinearTickStyle(length: 30, color: Color(0xFF0AEF05), thickness: 1),
          tickPosition: LinearElementPosition.cross,
          ranges: const [
            LinearGaugeRange(
              startValue: -0.5,
              endValue: 0.5, // Small value to make it look like a tick
              color: Color(0xFF0AEF05),
              startWidth: 120, // Adjust these values to change the size of the "tick"
              endWidth: 120,
              position: LinearElementPosition.cross,
            ),
          ],
          markerPointers: const [
            LinearShapePointer(
              shapeType: LinearShapePointerType.rectangle,
              value: 0, //Change to the proper values from the device
              width: 2,
              height: 160,
              color: Color(0xFFAA1717),
              position: LinearElementPosition.cross,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
