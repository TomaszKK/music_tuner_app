import 'package:flutter/material.dart';
import 'package:music_tuner/widgets/BluetoothConnectorWidget.dart';
import 'package:music_tuner/widgets/ThemeSwitchButton.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../providers/InstrumentProvider.dart';
import '../providers/ThemeManager.dart';
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
  String _appVersion = "";
  String theme = "dark";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  Future<void> _saveAppState() async {
    await DatabaseHelper().insertOrUpdateAll(
        TranspositionWidget.transpositionNotifier.value,
        instrumentNotesMap,
        manualNotesMap,
        HomePage.isNoteChanged.value,
        HomePage.isResetVisible.value,
        BluetoothConnectorWidget().deviceId,
        theme
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
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Round bottom-left corner
            bottomRight: Radius.circular(20), // Round bottom-right corner
          ),
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
              _buildThemeSwitchButton(themeManager), // Added ThemeSwitchButton
              Spacer(),
              _buildVersionContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildThemeSwitchButton(ThemeManager themeManager) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Switch Theme: $theme",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            fontFamily: 'Poppins',
          ),
        ),
        Switch(
          value: themeManager.isDark, // Check the current theme mode
          onChanged: (value) {
            themeManager.switchTheme(); // Toggle the theme
            theme = value ? "dark" : "light";
            _saveAppState();
          },
          activeColor: Theme.of(context).colorScheme.onPrimary,
          activeTrackColor: Theme.of(context).colorScheme.primaryContainer,
          trackOutlineColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
        ),
      ],
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
          style: ElevatedButton.styleFrom(
            foregroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.error,
            backgroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.error,
            shadowColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
          ),
          child: Text(
            settingValue,
            style: TextStyle(
              color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
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
          _buildVersionRow("Description:","IOT Mobile Tuner with ESP32 board for reading the frequency of the instrument and display it on the screen."),
          _buildVersionRow("Author", "Tomasz Kubik"),
          _buildVersionRow("Version", _appVersion),
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
              fontSize: 10
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
              fontSize: 10
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

}
