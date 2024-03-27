import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/guitarWidget.dart';
import 'package:music_tuner/widgets/bassWidget.dart';

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
      default:
        return const GuitarWidget(title: 'Guitar');
    }
  }
}
