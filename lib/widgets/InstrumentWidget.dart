import 'dart:math';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class InstrumentWidget extends StatefulWidget {
  const InstrumentWidget({super.key, required this.title});

  final String title;

  @override
  State<InstrumentWidget> createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
      ),
    );
  }
}