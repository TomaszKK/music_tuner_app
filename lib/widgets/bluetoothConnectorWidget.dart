import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:platform/platform.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothConnectorWidget {
  LocalPlatform platform = const LocalPlatform();

  void showBluetoothConnectorWidget(BuildContext context) {
    launchBluetooth(context);
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
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.scanResults,
                initialData: [],
                builder: (c, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.map((r) {
                      return ListTile(
                        title: Text(
                          r.device.remoteId.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(r.advertisementData.localName),
                        onTap: () {
                          connectToDevice(r.device);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void launchBluetooth(BuildContext context) async {
    await requestPermissions();

    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      print(state);
      if (state == BluetoothAdapterState.on) {
        print("Bluetooth is on");
        scanForDevices();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bluetooth is not enabled')),
        );
      }
    });

    if (platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  void scanForDevices() async {
    // var subscription = FlutterBluePlus.onScanResults.listen((results) {
    //   if (results.isNotEmpty) {
    //     ScanResult r = results.last; // the most recently found device
    //     print('${r.device.remoteId}: "${r.advertisementData.advName}" found!');
    //   }
    // },
    //   onError: (e) => print(e),
    // );
    //
    // FlutterBluePlus.cancelWhenScanComplete(subscription);
    //
    // // In your real app you should use `FlutterBluePlus.adapterState.listen` to handle all states
    // await FlutterBluePlus.adapterState.where((val) => val == BluetoothAdapterState.on).first;
    //
    // // Start scanning w/ timeout
    // // Optional: use `stopScan()` as an alternative to timeout
    // await FlutterBluePlus.startScan(
    //     withServices:[Guid("180D")], // match any of the specified services
    //     withNames:["Bluno"], // *or* any of the specified names
    //     timeout: Duration(seconds:15));
    //
    // // wait for scanning to stop
    // await FlutterBluePlus.isScanning.where((val) => val == false).first;

    print("Starting scan for devices...");
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 20));

    // Wait for the scan to complete
    await Future.delayed(const Duration(seconds: 20));

    // Stop the scan after 20 seconds
    print("Scan complete.");
    FlutterBluePlus.stopScan();

    // Print found devices
    FlutterBluePlus.scanResults.listen((results) {
      print("Found ${results.length} devices:");
      for (ScanResult r in results) {
        print('${r.device.remoteId}: "${r.advertisementData.localName}" found!');
      }
    }).onError((e) {
      print("Scan error: $e");
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    print('Connecting to ${device.remoteId}');
    await device.connect();
    print('Connected to ${device.remoteId}');
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.location,
    ].request();
  }
}
