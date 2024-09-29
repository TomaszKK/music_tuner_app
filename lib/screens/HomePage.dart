import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:music_tuner/providers/ThemeManager.dart';
import 'package:music_tuner/screens/SettingsPage.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import 'package:music_tuner/widgets/instrumentWidget.dart';
import 'package:music_tuner/widgets/InstrumentSelectionWidget.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';
import 'package:music_tuner/widgets/TranspositionWidget.dart';
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
            icon: SvgPicture.asset(
              'lib/assets/Transp_logo.svg',
              // color: Theme.of(context).colorScheme.onPrimaryContainer,  // Apply color if necessary
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimaryContainer,
                BlendMode.srcIn,
              ),
              width: 28,  // Set the width of the icon
              height: 28,  // Set the height of the icon
            ),
            onPressed: () {
              TranspositionWidget.showTranspositionWidget(context, _selectedInstrument);
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
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
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      minimumSize: const Size(100, 30),
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
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: InstrumentWidget(title: 'Instrument', selectedInstrument: _selectedInstrument),
              ),
              const Expanded(
                // fit: FlexFit.tight,
                child: TunerWidget(title: 'Tuner'),
              ),
              //const TunerWidget(title: 'Tuner'),
            ],
          );
        },
      )
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