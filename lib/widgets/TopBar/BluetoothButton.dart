import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';

class BluetoothButton extends StatelessWidget {
  final BluetoothConnectorWidget bluetoothConnectorWidget;

  const BluetoothButton({super.key, required this.bluetoothConnectorWidget});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: bluetoothConnectorWidget.isBluetoothConnected,
      builder: (context, isConnected, child) {
        return IconButton(
          icon: Icon(
            Icons.bluetooth_connected,
            color: isConnected ? Colors.green : Theme.of(context).colorScheme.onPrimaryContainer,
            size: 30,
          ),
          onPressed: () {
            bluetoothConnectorWidget.showBluetoothConnectorWidget(context);
          },
        );
      },
    );
  }

}
