import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/InstrumentSelectionWidget.dart';
import 'package:music_tuner/screens/HomePage.dart';

class HeaderRow extends StatelessWidget {
  final String selectedInstrument;

  const HeaderRow({super.key, required this.selectedInstrument});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 5),
        _SelectedInstrumentButton(
          selectedInstrument: selectedInstrument,
          onInstrumentChanged: (newInstrument) {
            HomePage.isResetVisible.value[newInstrument] = false;
          },
        ),
        const Spacer(),
        _ResetButton(selectedInstrument: selectedInstrument),
        const SizedBox(width: 5),
      ],
    );
  }
}

class _SelectedInstrumentButton extends StatelessWidget {
  final String selectedInstrument;
  final Function(String) onInstrumentChanged;

  const _SelectedInstrumentButton({
    required this.selectedInstrument,
    required this.onInstrumentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        minimumSize: const Size(100, 30),
        alignment: Alignment.centerLeft,
      ),
      child: Text(
        'Selected: $selectedInstrument',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
          fontFamily: 'Poppins',
          fontSize: 15,
        ),
      ),
      onPressed: () async {
        final newInstrument = await showDialog<String>(
          context: context,
          builder: (context) {
            return const Dialog(
              backgroundColor: Colors.transparent,
              elevation: 5,
              shadowColor: Colors.white,
              surfaceTintColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              child: InstrumentSelectionWidget(title: 'Select Instrument'),
            );
          },
        );

        if (newInstrument != null && newInstrument != selectedInstrument) {
          if (context.mounted) {
            HomePageState? homePageState = context.findAncestorStateOfType<HomePageState>();
            homePageState?.updateSelectedInstrument(newInstrument);
          }
          onInstrumentChanged(newInstrument);
        }
      },
    );
  }
}

class _ResetButton extends StatelessWidget {
  final String selectedInstrument;

  const _ResetButton({super.key, required this.selectedInstrument});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, bool>>(
      valueListenable: HomePage.isResetVisible,
      builder: (context, isVisible, child) {
        return isVisible[selectedInstrument] == true
            ? ElevatedButton(
          onPressed: () {
            HomePage.isNoteChanged.value = true;
            HomePage.isResetVisible.value[selectedInstrument] = false;
            HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
            HomePageState? homePageState = context.findAncestorStateOfType<HomePageState>();
            homePageState?.saveAppState();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            minimumSize: const Size(50, 30),
            alignment: Alignment.centerLeft,
          ),
          child: Text(
            'Reset all',
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Poppins',
              color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
            ),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }
}
