import 'package:flutter/material.dart';
import '../widgets/DatabaseHelper.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _resetDatabase() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.resetDatabaseToDefault();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetDatabase,
              style: ElevatedButton.styleFrom(
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                primary: Theme.of(context).colorScheme.primaryContainer,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontFamily: 'Poppins',
                ),
              ),
              child: const Text('Reset all instruments'),
            ),
          ],
        ),
      ),
    );
  }
}
