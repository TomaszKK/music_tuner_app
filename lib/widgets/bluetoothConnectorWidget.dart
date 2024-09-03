import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:platform/platform.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
typedef FloatValueCallback = void Function(double floatValue);

class BluetoothConnectorWidget {
  bool isDeviceConnected = false;
  BluetoothDevice ?connectedDevice;
  LocalPlatform platform = const LocalPlatform();
  ValueNotifier<bool> isBluetoothConnected = ValueNotifier<bool>(false);
  int takeThree = 0;
  double freqTemp = 0;
  double freqLast = 0;

  static ValueNotifier<double> frequencyNotifier = ValueNotifier<double>(0.0);
  // FloatValueCallback onFloatValueReceived;
  // BluetoothConnectorWidget({required this.onFloatValueReceived});

  void showBluetoothConnectorWidget(BuildContext context) {
    if(!isDeviceConnected) {
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
                            r.device.platformName,
                            style: const TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          onTap: () {
                            connectToDevice(r.device, context);
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
    }else{
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Device already connected.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(connectedDevice != null){
                      disconnectDevice(connectedDevice!, context);
                      Navigator.pop(context);
                    }
                    else{
                      print("No device connected");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: const Text(
                    'Disconnect',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
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
          const SnackBar(
              content: Text('Bluetooth is not enabled'),
              duration: Duration(seconds: 3),
          ),
        );
      }
    });

    if (platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  void scanForDevices() async {
    print("Starting scan for devices...");
    FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 20),
        withNames: ['TUNER IOT'],
        //withServices: [Guid('4fafc201-1fb5-459e-8fcc-c5c9c331914b')]
    );

    // Wait for the scan to complete
    await Future.delayed(const Duration(seconds: 20));

    // Stop the scan after 20 seconds
    // print("Scan complete.");
    // FlutterBluePlus.stopScan();
  }

  void connectToDevice(BluetoothDevice device, BuildContext context) async {
    print('Connecting to ${device.remoteId}');
    await device.connect(
      timeout: const Duration(seconds: 10),
      autoConnect: false,     //to change to true
    ).then((value) {
      isDeviceConnected = true;
      isBluetoothConnected.value = true;
      connectedDevice = device;
      Navigator.pop(context);

      discoverServices(device);

    }).catchError((e) {
      print("Error connecting to device: $e");
    });
  }

  void disconnectDevice(BluetoothDevice device, BuildContext context) async {
    print('Disconnecting from ${device.remoteId}');
    await device.disconnect().then((value) {
      isDeviceConnected = false;
      isBluetoothConnected.value = false;
    }).catchError((e) {
      print("Error disconnecting from device: $e");
    });
  }

  Future<void> discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // Find the characteristic you want to listen to
        if (characteristic.properties.notify) {
          listenForNotifications(characteristic);
        }
      }
    }
  }

  void listenForNotifications(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    characteristic.value.listen((value) {
      if (value.length >= 4) {
        final byteData = ByteData.sublistView(Uint8List.fromList(value));
        final floatValue = byteData.getFloat32(0, Endian.little);
        // print('Received float value: $floatValue');
        frequencyNotifier.value = floatValue;
      } else {
        print('Received data is too short to be a float: $value');
      }
    });
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
