import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';

class BluetoothButton extends StatelessWidget {
  final BluetoothConnectorWidget bluetoothConnectorWidget;

  const BluetoothButton({super.key, required this.bluetoothConnectorWidget});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.bluetooth_connected,
        color: bluetoothConnectorWidget.isBluetoothConnected.value
            ? Colors.green
            : Theme.of(context).colorScheme.onPrimaryContainer,
        size: 30,
      ),
      onPressed: () {
        bluetoothConnectorWidget.showBluetoothConnectorWidget(context);
      },
    );
  }

}
