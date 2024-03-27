import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:platform/platform.dart';

class BluetoothConnectorWidget {
  LocalPlatform platform = const LocalPlatform();

  void showBluetoothConnectorWidget(BuildContext context) {
    launchBluetooth();
    scanForDevices();
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
                  fontFamily: 'Poppins',
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

  void launchBluetooth() async{
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    var subscription = FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
      } else {
        // show an error to the user, etc
      }
    });

    if (platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    subscription.cancel();
  }

  void scanForDevices() async {
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        ScanResult r = results.last;
        print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
      }
    },
      onError: (e) => print(e),
    );

    FlutterBluePlus.cancelWhenScanComplete(subscription);

    await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;

    await FlutterBluePlus.startScan(
        withServices:[Guid("180D")],
        withNames:["Bluno"],
        timeout: Duration(seconds:15));

    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }
}