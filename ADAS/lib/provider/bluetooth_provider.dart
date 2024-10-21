import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothProvider with ChangeNotifier {
  List<ScanResult> scanResults = [];
  BluetoothDevice? selectedDevice;
  BluetoothCharacteristic? characteristic;
  bool connected = false;

  final StreamController<String> _dataController =
      StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataController.stream;

  ValueNotifier<bool> connectionStatusNotifier = ValueNotifier<bool>(false);
  ValueNotifier<String> rssiNotifier = ValueNotifier<String>('N/A');
  ValueNotifier<String> rangeNotifier = ValueNotifier<String>('N/A');
  ValueNotifier<String> deviceNameNotifier = ValueNotifier<String>('Unknown');
  ValueNotifier<String> speedNotifier = ValueNotifier<String>('0 cm/s');
  ValueNotifier<String> distanceNotifier = ValueNotifier<String>('0 cm');

  Future<void> requestPermission(BuildContext context) async {
    try {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (statuses[Permission.bluetooth]!.isGranted &&
          statuses[Permission.bluetoothScan]!.isGranted &&
          statuses[Permission.bluetoothConnect]!.isGranted &&
          statuses[Permission.location]!.isGranted) {
        // All permissions are granted
      } else {
        // Handle the case where permissions are not granted
        _showPermissionDialog(context);
      }
    } catch (e) {
      _showErrorDialog(
          context, 'Permission Error', 'Failed to request permissions.');
    }
  }

  void scanForDevices() {
    try {
      FlutterBluePlus.startScan(timeout: Duration(seconds: 4));
      FlutterBluePlus.scanResults.listen((results) {
        scanResults = results
            .where((result) => result.advertisementData.connectable)
            .toList();
        notifyListeners();
      });
    } catch (e) {
      // Handle scan error
    }
  }

  Future<void> connectToDevice(
      BluetoothDevice device, BuildContext context) async {
    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.properties.notify) {
            characteristic = c;
            await c.setNotifyValue(true);
            c.lastValueStream.listen((value) {
              _onDataReceived(Uint8List.fromList(value));
            });
          }
        }
      }
      connected = true;
      connectionStatusNotifier.value = true;
      selectedDevice = device;
      deviceNameNotifier.value = device.platformName;
      notifyListeners();

      // Update RSSI and range
      device.readRssi().then((rssi) {
        rssiNotifier.value = rssi.toString();
        rangeNotifier.value = calculateRange(rssi);
        notifyListeners();
      });
    } catch (e) {
      // Handle connection error
      _showConnectionErrorDialog(context);
    }
  }

  Future<void> disconnectFromDevice(BuildContext context) async {
    if (selectedDevice != null) {
      try {
        await selectedDevice!.disconnect();
        resetState();
      } catch (e) {
        _showErrorDialog(context, 'Disconnection Error',
            'Failed to disconnect from the device.');
      }
    }
  }

  void resetState() {
    connected = false;
    connectionStatusNotifier.value = false;
    rssiNotifier.value = 'N/A';
    rangeNotifier.value = 'N/A';
    deviceNameNotifier.value = 'Unknown';
    speedNotifier.value = '0 cm/s';
    distanceNotifier.value = '0 cm';
    notifyListeners();
  }

  String calculateRange(int rssi) {
    // Simple formula to estimate distance based on RSSI
    // This is a rough estimate and may not be accurate
    num distance = pow(10, (rssi + 69) / -20.0);
    return '${distance.toStringAsFixed(2)} meters';
  }

  void sendMessageToBluetooth(String val) async {
    try {
      if (characteristic != null) {
        await characteristic!.write(utf8.encode("$val\r\n"));
      }
    } catch (e) {
      // Handle send message error
    }
  }

  void _onDataReceived(Uint8List data) {
    String receivedData = utf8.decode(data);
    _dataController.add(receivedData);

    // Parse the received data
    List<String> lines = receivedData.split('\r\n');
    for (String line in lines) {
      if (line.startsWith('Distance: ')) {
        String distanceStr = line.replaceFirst('Distance: ', '');
        distanceNotifier.value = '$distanceStr cm';
        notifyListeners();
      } else if (line.startsWith('Speed: ')) {
        String speedStr = line.replaceFirst('Speed: ', '');
        speedNotifier.value = '$speedStr cm/s';
        notifyListeners();
      }
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permissions Required'),
          content:
              const Text('Please enable all required permissions in settings.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConnectionErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Error'),
          content:
              const Text('Failed to connect to the device. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
