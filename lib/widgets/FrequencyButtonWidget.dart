import 'package:flutter/material.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:provider/provider.dart';
import 'package:wheel_picker/wheel_picker.dart';

import 'ResetDoneButtonsWidget.dart';

class FrequencyButtonWidget extends StatefulWidget {
  final double initialFrequency;
  final ValueChanged<double> onFrequencyChanged;
  final double fontSize;

  const FrequencyButtonWidget({super.key, required this.initialFrequency, required this.fontSize, required this.onFrequencyChanged});

  @override
  _FrequencyButtonWidgetState createState() => _FrequencyButtonWidgetState();
}

class _FrequencyButtonWidgetState extends State<FrequencyButtonWidget> {
  late double selectedFrequency;
  late int integerPart;
  late int decimalPart;
  late WheelPickerController integerController;
  late WheelPickerController decimalController;

  @override
  void initState() {
    super.initState();
    selectedFrequency = widget.initialFrequency;
    integerPart = selectedFrequency.floor();
    decimalPart = ((selectedFrequency - integerPart) * 10).round();

    // Initialize controllers with the initial indices
    integerController = WheelPickerController(initialIndex: integerPart - 390, itemCount: 101);
    decimalController = WheelPickerController(initialIndex: decimalPart, itemCount: 10);
  }


  void _resetFrequency() {
      selectedFrequency = 440.0;
  }


  void _openFrequencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.background,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.5, // Limit height to half the screen
              ),
              child: Column(
                children: [
                  Text(
                    'Select Frequency',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        Expanded(
                          child: WheelPicker(
                            builder: (context, index) => Text(
                              (390 + index).toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            controller: integerController,
                            onIndexChanged: (index) {
                              // if (mounted) {
                                setState(() {
                                  integerPart = 390 + index;
                                  selectedFrequency = integerPart + decimalPart / 10.0;
                                });
                              // }
                            },
                            style: WheelPickerStyle(
                              itemExtent: 40,
                              squeeze: 1.25,
                              diameterRatio: .8,
                              surroundingOpacity: .25,
                              magnification: 1.2,
                            ),
                          ),
                        ),
                        Text(
                          '.',
                          style: TextStyle(fontSize: 20),
                        ),
                        Expanded(
                          child: WheelPicker(
                            builder: (context, index) => Text(
                              index.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                            controller: decimalController,
                            onIndexChanged: (index) {
                              // if (mounted) {
                                setState(() {
                                  decimalPart = index;
                                  selectedFrequency = integerPart + decimalPart / 10.0;
                                });
                              // }
                            },
                            style: WheelPickerStyle(
                              itemExtent: 40,
                              squeeze: 1.25,
                              diameterRatio: .8,
                              surroundingOpacity: .25,
                              magnification: 1.2,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ResetDoneButtons(
                    onReset: () {
                      _resetFrequency();
                      widget.onFrequencyChanged(selectedFrequency);
                      Navigator.of(context).pop();
                    },
                    onDone: () {
                      widget.onFrequencyChanged(selectedFrequency);
                      Navigator.of(context).pop();
                    },
                    resetColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.error,
                    doneColor: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    integerController.dispose();
    decimalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openFrequencyPicker(context),
      child: Container(
        alignment: Alignment.center,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Text(
          '${widget.initialFrequency.toStringAsFixed(1)} Hz',
          style: TextStyle(
            color: Provider.of<ThemeManager>(context).currentTheme.colorScheme.secondary,
            fontSize: widget.fontSize,
          ),
        ),
      ),
    );
  }
}