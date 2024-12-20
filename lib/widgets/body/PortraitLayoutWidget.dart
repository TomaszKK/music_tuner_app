import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/InstrumentWidget.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/body/HeaderRowWidget.dart';

class PortraitLayout extends StatelessWidget {
  final String selectedInstrument;

  const PortraitLayout(this.selectedInstrument, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HeaderRow(selectedInstrument: selectedInstrument),
        const SizedBox(height: 5),
        Expanded(
          child: InstrumentWidget(
            title: 'Instrument',
            selectedInstrument: selectedInstrument,
          ),
        ),
        Expanded(
          child: TunerWidget(
            title: 'Tuner',
            selectedInstrument: selectedInstrument,
          ),
        ),
      ],
    );
  }
}