import 'package:flutter/material.dart';
import 'package:music_tuner/providers/InstrumentProvider.dart';

class InstrumentSelectionWidget extends StatefulWidget {
  const InstrumentSelectionWidget({super.key, required this.title});

  final String title;

  @override
  State<InstrumentSelectionWidget> createState() => _InstrumentSelectionWidgetState();
}

class _InstrumentSelectionWidgetState extends State<InstrumentSelectionWidget> {
  String _selectedInstrument = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(15),
        children: InstrumentProvider.values
            .map((instrument) => ListTile(
          title: Text(
            instrument.toString().split('.').last,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            _selectInstrument(instrument.toString().split('.').last);
          },
        ))
            .toList(),
      ),
    );
  }

  void _selectInstrument(String instrument) {
    setState(() {
      _selectedInstrument = instrument;
    });
    Navigator.pop(context, _selectedInstrument); // Return selected instrument
  }
}