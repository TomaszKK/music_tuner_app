import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/InstrumentWidget.dart';

import '../providers/InstrumentProvider.dart';
import '../providers/noteInstrumentProvider.dart';
import '../screens/HomePage.dart';

class TranspositionWidget {
  static ValueNotifier<Map<String, int>> transpositionNotifier = ValueNotifier<Map<String, int>>({
    for (var instrument in InstrumentProvider.values) instrument.name: 0,
  });

  static void showTranspositionWidget(BuildContext context, String selectedInstrument) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow scrolling if needed
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return ValueListenableBuilder(
              valueListenable: InstrumentWidget.isTranspositionBound,
              builder: (context, isTranspositionBound, child) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight * 0.5, // Limit height to half the screen
                  ),
                  child: SingleChildScrollView( // Allow scrolling
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Size column to its children
                      children: <Widget>[
                        const Text(
                          'Change Notes Transposition',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                height: constraints.maxHeight * 0.1, // Adjust height for landscape
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!isTranspositionBound) {
                                      HomePage.isResetVisible.value[selectedInstrument] = true;
                                      HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
                                      var value = transpositionNotifier.value[selectedInstrument];
                                      if (value != null) {
                                        transpositionNotifier.value[selectedInstrument] = -1;
                                        transpositionNotifier.value = Map.from(transpositionNotifier.value);
                                      }
                                    }
                                  },
                                  child: const Text(
                                    '- 0.5',
                                    style: TextStyle(
                                      fontSize: 24, // Reduced font size for landscape
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: constraints.maxHeight * 0.1, // Adjust height for landscape
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (!isTranspositionBound) {
                                      HomePage.isResetVisible.value[selectedInstrument] = true;
                                      HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
                                      var value = transpositionNotifier.value[selectedInstrument];
                                      if (value != null) {
                                        transpositionNotifier.value[selectedInstrument] = 1;
                                        transpositionNotifier.value = Map.from(transpositionNotifier.value);
                                      }
                                    }
                                  },
                                  child: const Text(
                                    '+ 0.5',
                                    style: TextStyle(
                                      fontSize: 24, // Reduced font size for landscape
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () {
                                // Reset the transposition value for the selected instrument
                                transpositionNotifier.value[selectedInstrument] = 0;

                                // Restore notes from the manual changes map
                                instrumentNotesMap[selectedInstrument] = List<String>.from(manualNotesMap[selectedInstrument]!);

                                // Update the transpositionNotifier to trigger rebuilds
                                transpositionNotifier.value = Map.from(transpositionNotifier.value);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.red,
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 18.0, // Slightly smaller font size for landscape
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.green,
                              ),
                              child: const Text(
                                'Done',
                                style: TextStyle(
                                  fontSize: 18.0, // Slightly smaller font size for landscape
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
