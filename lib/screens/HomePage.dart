import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';

import '../providers/InstrumentProvider.dart';
import '../widgets/DatabaseHelper.dart';
import '../widgets/body/LandscapeLayoutWidget.dart';
import '../widgets/body/PortraitLayoutWidget.dart';
import '../widgets/TopBar/BluetoothButton.dart';
import '../widgets/TopBar/SettingsButton.dart';
import '../widgets/TopBar/TranspositionButton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;
  static ValueNotifier<bool> isNoteChanged = ValueNotifier<bool>(false);
  static ValueNotifier<Map<String, bool>> isResetVisible = ValueNotifier<Map<String, bool>>({
    for (var instrument in InstrumentProvider.values) instrument.name: false,
  });

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  String _selectedInstrument = 'Guitar';
  BluetoothConnectorWidget bluetoothConnectorWidget = BluetoothConnectorWidget();
  String espDeviceId = '';



  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _initializeState);
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initializeState() async {
    await _loadAppState();
    bluetoothConnectorWidget.isBluetoothConnected.addListener(() {
      setState(() {});
    });
  }

  Future<void> _loadAppState() async {
    var settings = await DatabaseHelper().getSettings();
    if (settings != null) {
      setState(() {
        _selectedInstrument = settings['selected_instrument'] ?? 'Guitar';
        HomePage.isNoteChanged.value = settings['is_note_changed'] == 1;
        String isResetVisibleJson = settings['is_reset_visible'];
        HomePage.isResetVisible.value = Map<String, bool>.from(
            jsonDecode(isResetVisibleJson)
        );
        espDeviceId = settings['device_id'] ?? '';
      });
    }
  }

  Future<void> saveAppState() async {
    await DatabaseHelper().insertOrUpdateSettings(
      _selectedInstrument,
      HomePage.isNoteChanged.value,
      HomePage.isResetVisible.value,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      saveAppState();
    }
  }

  void updateSelectedInstrument(String newInstrument) {
    setState(() {
      _selectedInstrument = newInstrument;
    });
    saveAppState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _resetAllChanges() {
    setState(() {
      HomePage.isNoteChanged.value = true;
      HomePage.isResetVisible.value = {
        for (var instrument in InstrumentProvider.values) instrument.name: false,
      };
      saveAppState();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: isPortrait ? PortraitLayout(_selectedInstrument) : LandscapeLayout(_selectedInstrument),
    );
  }

  AppBar _buildAppBar(BuildContext context){
    return AppBar(
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
      actions: [
        TranspositionButton(selectedInstrument: _selectedInstrument),
        BluetoothButton(bluetoothConnectorWidget: bluetoothConnectorWidget),
        SettingsButton(onSettingsChanged: _loadAppState),
      ],
    );
  }
}