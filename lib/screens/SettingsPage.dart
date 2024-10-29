import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';
import 'package:music_tuner/widgets/TunerWidget.dart';
import '../providers/InstrumentProvider.dart';
import '../providers/noteInstrumentProvider.dart';
import '../widgets/DatabaseHelper.dart';
import '../widgets/TranspositionWidget.dart';
import 'HomePage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;
  static ValueNotifier<bool> isReset = ValueNotifier<bool>(false);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _saveAppState() async {
    await DatabaseHelper().insertOrUpdateAll(
        TranspositionWidget.transpositionNotifier.value,
        instrumentNotesMap,
        manualNotesMap,
        HomePage.isNoteChanged.value,
        HomePage.isResetVisible.value,
        BluetoothConnectorWidget().deviceId,
    );
  }

  Future<void> _resetDatabase() async {
    TranspositionWidget.transpositionNotifier.value = {
      for (var instrument in InstrumentProvider.values) instrument.name: 0,
    };
    HomePage.isNoteChanged.value = true;
    HomePage.isResetVisible.value = {
      for (var instrument in InstrumentProvider.values) instrument.name: false,
    };
    instrumentNotesMap = Map<String, List<String>>.from(noteInstrumentDefaultProvider);
    manualNotesMap = Map<String, List<String>>.from(noteInstrumentDefaultProvider);
    BluetoothConnectorWidget().deviceId = '';
    SettingsPage.isReset.value = true;
    _saveAppState();
    Navigator.pop(context, true);
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
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          // color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              _buildSettingRow("Reset to default", "Reset", "all"),
              _buildSettingRow("Reset connected device", "Reset", "ble"),
              Spacer(),
              _buildVersionContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSettingRow(String settingName, String settingValue, String itemKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          settingName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontFamily: 'Poppins',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (itemKey == "all") {
              _resetDatabase();
              setState(() {
              });
            } else if (itemKey == "ble") {
              // Reset the connected device
              final dbHelper = DatabaseHelper();
              dbHelper.insertOrUpdateBLE('');
              Navigator.pop(context, true);
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: Text(
            settingValue,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Container _buildVersionContainer() {
    return Container(
      // padding: const EdgeInsets.only(),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildVersionRow("Description:","IOT Tuner with ESP32 board for reading the frequency of the instrument and display it on the screen"),
          _buildVersionRow("Author", "Tomasz Kubik"),
          _buildVersionRow("Version", "1.0.0"),
        ],
      ),
    );
  }

  Row _buildVersionRow(String settingName, String settingValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 100,
          child: Text(
            settingName,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        // Value text
        Expanded(
          child: Text(
            settingValue,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontFamily: 'Poppins',
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

}
