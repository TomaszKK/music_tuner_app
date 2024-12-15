import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/InstrumentWidget.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/body/HeaderRowWidget.dart';

class LandscapeLayout extends StatelessWidget {
  final String selectedInstrument;

  const LandscapeLayout(this.selectedInstrument, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: InstrumentWidget(
            title: 'Instrument',
            selectedInstrument: selectedInstrument,
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              HeaderRow(selectedInstrument: selectedInstrument),
              const SizedBox(height: 5),
              Expanded(
                child: TunerWidget(
                  title: 'Tuner',
                  selectedInstrument: selectedInstrument,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}