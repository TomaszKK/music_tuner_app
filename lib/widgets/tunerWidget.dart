import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'bluetoothConnectorWidget.dart';




class TunerWidget extends StatefulWidget {
  const TunerWidget({super.key, required this.title});
  final String title;


  @override
  State<TunerWidget> createState() => _TunerWidgetState();
}

class _TunerWidgetState extends State<TunerWidget> {
  BluetoothConnectorWidget bluetoothConnector = BluetoothConnectorWidget(onFloatValueReceived: (double floatValue) {

    gaugeValue.value = floatValue;
  });



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
              child: Text(
                'Someting',
                style: TextStyle(
                  color: ThemeManager().currentTheme.colorScheme.secondary,
                  fontSize: 20,
                ),
              )
            ),
            const SizedBox(width: 20),
            Container(
              alignment: Alignment.center,
              height: 100,
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'G',
                    style: TextStyle(
                      color: ThemeManager().currentTheme.colorScheme.secondary,
                      fontSize: 40,
                    ),
                  ),
                  Text(
                    'Tuned',
                    style: TextStyle(
                      color: ThemeManager().currentTheme.colorScheme.secondary,
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
              child: Text(
                  '440 Hz',
                  style: TextStyle(
                    color: ThemeManager().currentTheme.colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // SfLinearGauge(
        //   minimum: -50,
        //   maximum: 50,
        //   interval: 10,
        //   minorTicksPerInterval: 3,
        //   showTicks: true,
        //   showLabels: false,
        //   majorTickStyle: LinearTickStyle(length: 80, color: ThemeManager().currentTheme.colorScheme.secondary, thickness: 2),
        //   minorTickStyle: LinearTickStyle(length: 30, color: ThemeManager().currentTheme.colorScheme.secondary, thickness: 1),
        //   tickPosition: LinearElementPosition.cross,
        //   ranges: [
        //     LinearGaugeRange(
        //       startValue: -0.5,
        //       endValue: 0.5, // Small value to make it look like a tick
        //       color: ThemeManager().currentTheme.colorScheme.secondary,
        //       startWidth: 120, // Adjust these values to change the size of the "tick"
        //       endWidth: 120,
        //       position: LinearElementPosition.cross,
        //     ),
        //   ],
        //   markerPointers: const [
        //     LinearShapePointer(
        //       shapeType: LinearShapePointerType.rectangle,
        //       value: value, //Change to the proper values from the device
        //       width: 2,
        //       height: 160,
        //       color: Color(0xFFAA1717),
        //       position: LinearElementPosition.cross,
        //     ),
        //   ],
        // ),
        ValueListenableBuilder<double>(
          valueListenable: gaugeValue, // Listen to changes in gaugeValue
          builder: (context, value, child) {
            return SfLinearGauge(
              minimum: -50,
              maximum: 50,
              interval: 10,
              minorTicksPerInterval: 3,
              showTicks: true,
              showLabels: false,
              majorTickStyle: LinearTickStyle(
                length: 80,
                color: ThemeManager().currentTheme.colorScheme.secondary,
                thickness: 2,
              ),
              minorTickStyle: LinearTickStyle(
                length: 30,
                color: ThemeManager().currentTheme.colorScheme.secondary,
                thickness: 1,
              ),
              tickPosition: LinearElementPosition.cross,
              ranges: [
                LinearGaugeRange(
                  startValue: -0.5,
                  endValue: 0.5,
                  color: ThemeManager().currentTheme.colorScheme.secondary,
                  startWidth: 120,
                  endWidth: 120,
                  position: LinearElementPosition.cross,
                ),
              ],
              markerPointers: [
                LinearShapePointer(
                  shapeType: LinearShapePointerType.rectangle,
                  value: value, // Use the current value from gaugeValue
                  width: 2,
                  height: 160,
                  color: const Color(0xFFAA1717),
                  position: LinearElementPosition.cross,
                ),
              ],
            );
          },
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  // @override
  // void dispose() {
  //   gaugeValue.dispose();
  //   super.dispose();
  // }
}
