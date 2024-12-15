import 'package:flutter/material.dart';
import 'package:music_tuner/screens/SettingsPage.dart';

class SettingsButton extends StatelessWidget {
  final Future<void> Function() onSettingsChanged;

  const SettingsButton({super.key, required this.onSettingsChanged});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.settings,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
        size: 30,
      ),
      onPressed: () async {
        final resetOccurred = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsPage(title: "Settings"),
          ),
        );
        if (resetOccurred == true) {
          await onSettingsChanged();
        }
      },
    );
  }
}