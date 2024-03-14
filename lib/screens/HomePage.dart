import 'package:flutter/material.dart';
import 'package:music_tuner/screens/SettingsPage.dart';
import 'package:music_tuner/widgets/tunerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
      body: Center(
        child: Column(
          children: <Widget>[
            ButtonBar(
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    minimumSize: const Size(100, 30),
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    'Selected Instrument: Guitar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                      fontFamily: 'Poppins',
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(
              child: TunerWidget(title: 'Tuner'),
            ),
          ],
        ),
      ),
    );
  }
}