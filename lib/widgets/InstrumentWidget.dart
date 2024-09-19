import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/GuitarWidget.dart';
import 'package:music_tuner/widgets/instrumentWidgetsDir/BassWidget.dart';

import 'instrumentWidgetsDir/TenorhornWidget.dart';

class InstrumentWidget extends StatefulWidget {
  const InstrumentWidget({Key? key, required this.title, required this.selectedInstrument}) : super(key: key);

  final String title;
  final String selectedInstrument;


  @override
  State<InstrumentWidget> createState() => _InstrumentWidgetState();
}

class _InstrumentWidgetState extends State<InstrumentWidget> {
  @override
  Widget build(BuildContext context) {
    switch(widget.selectedInstrument){
      case 'Guitar':
        return const Center(
          child: GuitarWidget(title: 'Guitar'),
        );
      case 'Bass':
        return const Center(
          child: BassWidget(title: 'Bass'),
        );
      case 'Tenorhorn':
        return const Center(
          child: TenorhornWidget(title: 'Tenorhorn'),
        );
      default:
        return const GuitarWidget(title: 'Guitar');
    }
  }
}
