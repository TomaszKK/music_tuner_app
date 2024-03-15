import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/SettingsPage.dart';
import 'package:music_tuner/widgets/tunerWidget.dart';
import 'package:music_tuner/widgets/instrumentWidget.dart';
import 'package:music_tuner/widgets/InstrumentSelectionWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedInstrument = 'Guitar';

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
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 30,
            ),
            onPressed: () {
              _showBluetoothStatus();
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
          const Expanded(
            child: InstrumentWidget(title: 'Instrument'),
          ),
          const TunerWidget(title: 'Tuner'),
        ],
      ),
    );
  }

  void _showBluetoothStatus() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Select device to connect to:',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontManager.poppins,
                ),
              ),
             ListView(
               shrinkWrap: true,
               children: <Widget>[
                 ListTile(
                   title: const Text(
                     'Device 1',
                     style: TextStyle(
                       color: Colors.white,
                     ),
                   ),
                   onTap: () {
                     // Respond to button press
                   },
                 ),
                 ListTile(
                   title: const Text(
                     'Device 2',
                     style: TextStyle(
                       color: Colors.white,
                     ),
                   ),
                   onTap: () {
                     // Respond to button press
                   },
                 ),
               ],
             ),
            ],
          ),
        );
      },
    );
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