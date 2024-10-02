import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:platform/platform.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:loading_animation_widget/loading_animation_widget.dart';

typedef FloatValueCallback = void Function(double floatValue);

class BluetoothConnectorWidget {
  bool isDeviceConnected = false;
  BluetoothDevice? connectedDevice;
  LocalPlatform platform = const LocalPlatform();
  ValueNotifier<bool> isBluetoothConnected = ValueNotifier<bool>(false);
  ValueNotifier<bool> isConnecting = ValueNotifier<bool>(false); // Added ValueNotifier for connecting state
  int takeThree = 0;
  double freqTemp = 0;
  double freqLast = 0;
  int noteClearCount = 0;

  static ValueNotifier<double> frequencyNotifier = ValueNotifier<double>(0.0);

  // Controller to handle scan results state
  ValueNotifier<bool> isScanning = ValueNotifier<bool>(false);
  ValueNotifier<List<ScanResult>> scanResults = ValueNotifier<List<ScanResult>>([]);
  Completer<void>? _scanCompleter;

  void showBluetoothConnectorWidget(BuildContext context) {
    if (!isDeviceConnected) {
      launchBluetooth(context);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ValueListenableBuilder<bool>(
            valueListenable: isScanning,
            builder: (context, scanning, child) {
              return Container(
                padding: const EdgeInsets.all(16.0),
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
                    scanning ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.green,
                        size: 20.0,
                      ),
                    ) : ValueListenableBuilder<List<ScanResult>>(
                      valueListenable: scanResults,
                      builder: (context, results, child) {
                        if (results.isNotEmpty) {
                          return ListView(
                            shrinkWrap: true,
                            children: results.map((r) {
                              return ListTile(
                                title: Text(
                                  r.device.platformName,
                                  style: const TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                                onTap: () {
                                  // Show loading animation while connecting
                                  isConnecting.value = true;
                                  connectToDevice(r.device, context);
                                },
                              );
                            }).toList(),
                          );
                        } else {
                          return const Center(
                            child: Text(
                              'No devices found. Please try again.',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    // Display a loading animation while connecting
                    ValueListenableBuilder<bool>(
                      valueListenable: isConnecting,
                      builder: (context, connecting, child) {
                        return connecting ? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ) : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
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
                    if (connectedDevice != null) {
                      disconnectDevice(connectedDevice!, context);
                      Navigator.pop(context);
                    } else {
                      print("No device connected");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red),
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bluetooth is not supported by this device')),
      );
      return;
    }

    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.on) {
        print("Bluetooth is on");
        await scanForDevices();  // Ensure scanning is awaited
      } else if (state == BluetoothAdapterState.off) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bluetooth is not enabled')),
        );
      }
    });

    if (platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  Future<void> scanForDevices() async {
    print("Starting scan for devices...");
    isScanning.value = true;  // Show loader
    scanResults.value = [];  // Clear previous results

    _scanCompleter = Completer<void>();

    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
      withNames: ['TUNER IOT'],
      // withServices: [Guid('4fafc201-1fb5-459e-8fcc-c5c9c331914b')]
    );

    FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty && !_scanCompleter!.isCompleted) {
        scanResults.value = results;
        _scanCompleter!.complete();  // Complete the scan if devices are found
      }
    });

    // Wait for either scan completion or timeout
    await Future.any([
      _scanCompleter!.future,
      Future.delayed(const Duration(seconds: 10))
    ]);

    // Stop scanning
    FlutterBluePlus.stopScan();
    print("Scan completed");
    isScanning.value = false;  // Hide loader
  }

  void connectToDevice(BluetoothDevice device, BuildContext context) async {
    // print('Connecting to ${device.remoteId}');

    // Update the connecting state to show loading animation
    isConnecting.value = true;

    try {
      await device.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );
      isDeviceConnected = true;
      isBluetoothConnected.value = true;
      connectedDevice = device;
      Navigator.pop(context);

      // Listen for connection state changes to detect disconnection
      device.state.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.disconnected) {
          // Connection lost, update isBluetoothConnected and UI
          isDeviceConnected = false;
          isBluetoothConnected.value = false;
          connectedDevice = null; // Clear the connected device
        }
      });

      // Discover services after connection
      await discoverServices(device);
    } catch (e) {
      print("Error connecting to device: $e");
    } finally {
      isConnecting.value = false;
    }
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
        if (floatValue != 0) {
          frequencyNotifier.value = floatValue;
          noteClearCount = 0;
        }else{
          noteClearCount++;
        }

        if(noteClearCount > 20){
          frequencyNotifier.value = 0.0;
        }
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
