import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/SettingsPage.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/instrumentWidget.dart';
import 'package:music_tuner/widgets/InstrumentSelectionWidget.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedInstrument = 'Guitar';
  BluetoothConnectorWidget bluetoothConnectorWidget = BluetoothConnectorWidget();

  @override
  void initState() {
    super.initState();

    bluetoothConnectorWidget.isBluetoothConnected.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleSpacing: 20,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontFamily: 'Poppins',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 30,
            ),
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(
              Icons.bluetooth_connected,
              color: bluetoothConnectorWidget.isBluetoothConnected.value
                  ? Colors.green  // Change to green if connected
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              size: 30,
            ),
            onPressed: () {
              customEnableBT(context);
              // bluetoothConnectorWidget.showBluetoothConnectorWidget(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage(title: 'Settings')),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  minimumSize: const Size(100, 30),
                  alignment: Alignment.centerLeft,
                ),
                child: Text(
                  'Selected Instrument: ${_getPickedInstrument()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
                onPressed: () {
                  _showInstrumentSelection();
                },
              ),
            ],
          ),
          Expanded(
            child: InstrumentWidget(title: 'Instrument', selectedInstrument: _selectedInstrument),
          ),
          const TunerWidget(title: 'Tuner'),
          //const TunerWidget(title: 'Tuner'),
        ],
      ),
    );
  }


  Future<void> customEnableBT(BuildContext context) async {
    BluetoothEnable.enableBluetooth.then((result) {
      if (result == "true") {
        bluetoothConnectorWidget.showBluetoothConnectorWidget(context);
      }
    });
  }

  void _showInstrumentSelection() async{
    final selectedInstrument = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
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

    if (selectedInstrument != null) {
      setState(() {
        _selectedInstrument = selectedInstrument;
      });
    }
  }

  String _getPickedInstrument() {
    return _selectedInstrument ?? 'Guitar';
  }

}