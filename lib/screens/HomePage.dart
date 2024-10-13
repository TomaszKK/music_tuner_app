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

import '../providers/InstrumentProvider.dart';
import '../providers/noteInstrumentProvider.dart';
import '../widgets/DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, required this.title});

  final String title;
  static ValueNotifier<bool> isNoteChanged = ValueNotifier<bool>(false);
  static ValueNotifier<Map<String, bool>> isResetVisible = ValueNotifier<Map<String, bool>>({
    for (var instrument in InstrumentProvider.values) instrument.name: false,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedInstrument = 'Guitar';
  BluetoothConnectorWidget bluetoothConnectorWidget = BluetoothConnectorWidget();

  @override
  void initState() {
    super.initState();

    _loadAppState();

    bluetoothConnectorWidget.isBluetoothConnected.addListener(() {
      setState(() {});
    });
    // WidgetsBinding.instance.addObserver(this as WidgetsBindingObserver);
  }

  Future<void> _loadAppState() async {
    // Load saved state from SQLite
    var settings = await DatabaseHelper().getSettings();

    if (settings != null) {
      setState(() {
        _selectedInstrument = settings['selected_instrument'] ?? 'Guitar';
        HomePage.isNoteChanged.value = settings['is_note_changed'] == 1;
        HomePage.isResetVisible.value = Map<String, bool>.from(settings['is_reset_visible']);
      });
    }
  }

  Future<void> _saveAppState() async {
    // Save the current state to SQLite
    await DatabaseHelper().insertOrUpdateSettings(
      _selectedInstrument,
      HomePage.isNoteChanged.value,
      HomePage.isResetVisible.value,  // Save the isResetVisible map
    );
  }

  void _resetAllChanges() {
    setState(() {
      HomePage.isNoteChanged.value = true;
      HomePage.isResetVisible.value = {
        for (var instrument in InstrumentProvider.values) instrument.name: false,
      };

      _saveAppState();  // Save the state
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _saveAppState();  // Save app state when app is paused or inactive
    }
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);  // Remove observer on dispose
    super.dispose();
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
                  const SizedBox(width: 5),
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
                      'Selected: ${_getPickedInstrument()}',
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
                  ValueListenableBuilder(
                    valueListenable: HomePage.isResetVisible,
                    builder: (context, isVisible, child) {
                      return isVisible[_selectedInstrument]!
                          ? ElevatedButton(
                        onPressed: () {
                          // Reset all changes
                          _resetAllChanges();
                          HomePage.isResetVisible.value[_selectedInstrument] = false;
                          HomePage.isResetVisible.value = Map.from(HomePage.isResetVisible.value);
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
                          : const SizedBox.shrink(); // Show nothing if not visible
                    },
                  ),
                  const SizedBox(width: 5),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: InstrumentWidget(title: 'Instrument', selectedInstrument: _selectedInstrument),
              ),
              Expanded(
                // fit: FlexFit.tight,
                child: TunerWidget(title: 'Tuner', selectedInstrument: _selectedInstrument),
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