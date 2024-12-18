import 'package:flutter/material.dart';
import 'package:music_tuner/providers/InstrumentProvider.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeManager.dart';

class InstrumentSelectionWidget extends StatefulWidget {
  const InstrumentSelectionWidget({super.key, required this.title, required this.selectedInstrument});

  final String title;
  final String selectedInstrument;

  @override
  State<InstrumentSelectionWidget> createState() => _InstrumentSelectionWidgetState();
}

class _InstrumentSelectionWidgetState extends State<InstrumentSelectionWidget> {
  late String _selectedInstrument;

  @override
  void initState() {
    super.initState();
    _selectedInstrument = widget.selectedInstrument;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(15),
        children: InstrumentProvider.values.map((instrument) {
          final instrumentName = instrument.toString().split('.').last;
          final isSelected = _selectedInstrument == instrumentName;

          return ListTile(
            title: Text(
              instrumentName
                  .toString()
                  .split('.')
                  .last,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onPrimaryContainer,
              ),
            ),
            selected: isSelected,
            selectedTileColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.surface.withOpacity(0.2),
            focusColor: Provider
                .of<ThemeManager>(context)
                .currentTheme
                .colorScheme
                .secondary,
            splashColor: Provider
                .of<ThemeManager>(context)
                .currentTheme
                .colorScheme
                .secondary,
            hoverColor: Provider
                .of<ThemeManager>(context)
                .currentTheme
                .colorScheme
                .secondary,
            selectedColor: Provider
                .of<ThemeManager>(context)
                .currentTheme
                .colorScheme
                .secondary,
            onTap: () {
              _selectInstrument(instrumentName);
            },
          );
        })
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