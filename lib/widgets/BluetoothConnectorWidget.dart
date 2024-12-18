import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:platform/platform.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'package:location/location.dart' as location_handler;
import 'dart:typed_data';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../providers/ThemeManager.dart';
import 'DatabaseHelper.dart';

typedef FloatValueCallback = void Function(double floatValue);

class BluetoothConnectorWidget {
  bool isDeviceConnected = false;
  BluetoothDevice? connectedDevice;
  LocalPlatform platform = const LocalPlatform();
  ValueNotifier<bool> isBluetoothConnected = ValueNotifier<bool>(false);
  ValueNotifier<bool> isConnecting = ValueNotifier<bool>(false); // Added ValueNotifier for connecting state
  String deviceId = '';
  int takeThree = 0;
  double freqTemp = 0;
  double freqLast = 0;
  int noteClearCount = 0;

  static ValueNotifier<double> frequencyNotifier = ValueNotifier<double>(0.0);

  // Controller to handle scan results state
  ValueNotifier<bool> isScanning = ValueNotifier<bool>(false);
  ValueNotifier<List<ScanResult>> scanResults = ValueNotifier<List<ScanResult>>([]);
  Completer<void>? _scanCompleter;

  Future<void> _loadAppState() async {
    var settings = await DatabaseHelper().getSettings();
    if (settings != null) {
      // setState(() {
      deviceId = settings['device_id'] ?? '';
      // });
    }
  }

  Future<void> _saveAppState() async {
    await DatabaseHelper().insertOrUpdateBLE(deviceId);
  }

  void showBluetoothConnectorWidget(BuildContext context) async {
    // Step 1: Ensure all permissions and services are enabled
    bool allServicesEnabled = await checkAndRequestServices(context);

    if (allServicesEnabled) {
      // Step 2: If all services are enabled, load app state and start scanning
      await _loadAppState();
      if (!isDeviceConnected) {
        scanForDevices(context);

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.background,
          builder: (BuildContext context) {
            return ValueListenableBuilder<bool>(
              valueListenable: isScanning,
              builder: (context, scanning, child) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Select device to connect to:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      scanning
                          ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.secondary,
                          size: 20.0,
                        ),
                      )
                          : ValueListenableBuilder<List<ScanResult>>(
                        valueListenable: scanResults,
                        builder: (context, results, child) {
                          if (results.isNotEmpty) {
                            return ListView(
                              shrinkWrap: true,
                              children: results.map((r) {
                                return ListTile(
                                  title: Text(
                                    r.device.platformName,
                                    style: TextStyle(
                                      color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.secondary,
                                    ),
                                  ),
                                  onTap: () {
                                    isConnecting.value = true;
                                    connectToDevice(r.device, context);
                                  },
                                );
                              }).toList(),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'No devices found. Please try again.',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.error,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isConnecting,
                        builder: (context, connecting, child) {
                          return connecting
                              ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.secondary,
                              size: 30.0,
                            ),
                          )
                              : const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }
      else{
        showModalBottomSheet(
          context: context,
          backgroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.background,
          builder: (BuildContext context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Device already connected.',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (connectedDevice != null) {
                        disconnectDevice(connectedDevice!, context);
                        Navigator.pop(context);
                      } else {
                        // print('No connected device to disconnect');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.error,
                    ),
                    child: Text(
                      'Disconnect',
                      style: TextStyle(
                        fontSize: 18.0, // Slightly smaller font size for landscape
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      // Step 3: Show modal with error message if any service is disabled
      showModalBottomSheet(
        context: context,
        backgroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.background,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'Please enable Bluetooth and Location Services to continue.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.surface,
                    backgroundColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.surface,
                    shadowColor: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Provider.of<ThemeManager>(context, listen: false).currentTheme.colorScheme.onPrimaryContainer,
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

  Future<bool> checkAndRequestServices(BuildContext context) async {
    location_handler.Location location = location_handler.Location();
    bool _serviceEnabled = await location.serviceEnabled();
    bool bluetoothEnabled = (await FlutterBluePlus.adapterState.first ==
        BluetoothAdapterState.on);
    location_handler.PermissionStatus _permissionGranted =
    await location.hasPermission();

    // Check and request Location Services
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location must be enabled')),
        );
        return false;
      }
    }

    // Check and request Location Permission
    if (_permissionGranted == location_handler.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != location_handler.PermissionStatus.granted) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Location permission is required')),
        // );
        return false;
      }
    }

    // Check and enable Bluetooth
    if (!bluetoothEnabled) {
      try {
        await FlutterBluePlus.turnOn();
        bluetoothEnabled = (await FlutterBluePlus.adapterState.first ==
            BluetoothAdapterState.on);
        if (!bluetoothEnabled) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Bluetooth must be enabled')),
          // );
          return false;
        }
      } catch (e) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Failed to enable Bluetooth')),
        // );
        return false;
      }
    }

    return true;
  }

  Future<void> scanForDevices(BuildContext context) async {
    isScanning.value = true;  // Show loader
    scanResults.value = [];  // Clear previous results

    _scanCompleter = Completer<void>();

    FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 15),
      withNames: ['TUNER HRT-1'],
      // withServices: [Guid('4fafc201-1fb5-459e-8fcc-c5c9c331914b')]
    );

    FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty && !_scanCompleter!.isCompleted) {
        scanResults.value = results;
        _scanCompleter!.complete();
        for(var result in results){
          if(result.device.remoteId.toString() == deviceId){
            connectToDevice(result.device, context);
            break;
          }
        }
      }
    });

    // Wait for either scan completion or timeout
    await Future.any([
      _scanCompleter!.future,
      Future.delayed(const Duration(seconds: 10))
    ]);

    // Stop scanning
    FlutterBluePlus.stopScan();
    isScanning.value = false;  // Hide loader
  }

  void connectToDevice(BluetoothDevice device, BuildContext context) async {

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
      deviceId = device.remoteId.toString();
      _saveAppState();
      Navigator.pop(context);

      // Listen for connection state changes to detect disconnection
      device.state.listen((BluetoothConnectionState state) {
        if (state == BluetoothConnectionState.disconnected) {
          // Connection lost, update isBluetoothConnected and UI
          isDeviceConnected = false;
          isBluetoothConnected.value = false;
          connectedDevice = null; // Clear the connected device
          frequencyNotifier.value = 0.0; // Reset frequency notifier
        }
      });

      // Discover services after connection
      await discoverServices(device);
      // device.requestConnectionPriority(connectionPriorityRequest: ConnectionPriority.high);

      int mtu = await device.requestMtu(128);

    } catch (e) {
      print("Error connecting to device: $e");
    } finally {
      isConnecting.value = false;
    }
  }

  void disconnectDevice(BluetoothDevice device, BuildContext context) async {
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

        if(noteClearCount > 5){
          frequencyNotifier.value = 0.0;
        }
      } else {
        print('Received data is too short to be a float: $value');
      }
    });
  }

  Future<void> requestPermissions() async {
    await [
      permission_handler.Permission.bluetoothScan,
      permission_handler.Permission.bluetoothConnect,
      permission_handler.Permission.bluetoothAdvertise,
      permission_handler.Permission.location,
    ].request();
  }
}