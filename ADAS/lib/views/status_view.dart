import 'package:adas/app_localizations.dart';
import 'package:adas/provider/bluetooth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusView extends StatefulWidget {
  @override
  StatusViewState createState() => StatusViewState();
}

class StatusViewState extends State<StatusView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BluetoothProvider>(
      builder: (context, bluetoothProvider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<String>(
              valueListenable: bluetoothProvider.rssiNotifier,
              builder: (context, rssi, child) {
                return statusItem(
                    AppLocalizations.of(context).translate('rssi'),
                    rssi,
                    Icons.signal_cellular_alt);
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: bluetoothProvider.rangeNotifier,
              builder: (context, range, child) {
                return statusItem(
                    AppLocalizations.of(context).translate('range'),
                    range,
                    Icons.wifi_tethering);
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: bluetoothProvider.deviceNameNotifier,
              builder: (context, deviceName, child) {
                return statusItem(
                    AppLocalizations.of(context).translate('device'),
                    deviceName,
                    Icons.devices);
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: bluetoothProvider.speedNotifier,
              builder: (context, speed, child) {
                return statusItem(
                    AppLocalizations.of(context).translate('speed'),
                    speed,
                    Icons.speed);
              },
            ),
            ValueListenableBuilder<bool>(
              valueListenable: bluetoothProvider.connectionStatusNotifier,
              builder: (context, isConnected, child) {
                return statusItem(
                  AppLocalizations.of(context).translate('bluetooth'),
                  isConnected
                      ? AppLocalizations.of(context).translate('connected')
                      : AppLocalizations.of(context).translate('notconnected'),
                  Icons.bluetooth,
                  isConnected ? Colors.green : Colors.red,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget statusItem(String label, String value, IconData iconData,
      [Color? textColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.blue,
            size: 50,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: textColor ?? Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  void showErrorDialog(BuildContext context, String title, String message) {
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
