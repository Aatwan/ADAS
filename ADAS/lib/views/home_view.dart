import 'package:adas/app_localizations.dart';
import 'package:adas/provider/bluetooth_provider.dart';
import 'package:adas/views/control_options_view.dart';
import 'package:adas/views/settings_view.dart';
import 'package:adas/views/status_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // Ensure this import is included

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    try {
      await Provider.of<BluetoothProvider>(context, listen: false)
          .requestPermission(context);
    } catch (e) {
      _showErrorDialog(
          context, 'Permission Error', 'Failed to request permissions.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const ControlOptionsView(),
      StatusView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Set the type to fixed
        selectedItemColor: Colors.white,
        backgroundColor: Theme.of(context)
            .primaryColor, // Explicitly set the background color
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard),
              label: AppLocalizations.of(context)
                  .translate('options')), // Add the new item
          BottomNavigationBarItem(
              icon: const Icon(Icons.query_stats_rounded),
              label: AppLocalizations.of(context).translate('status')),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context).translate('settings')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBluetoothDevicesDialog(context);
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.bluetooth,
          color: Colors.white,
        ),
      ),
    );
  }

  void showBluetoothDevicesDialog(BuildContext context) {
    Provider.of<BluetoothProvider>(context, listen: false)
        .scanForDevices(); // Start scanning for devices

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Bluetooth Device'),
              content: Consumer<BluetoothProvider>(
                builder: (context, bluetoothProvider, child) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (bluetoothProvider.scanResults.isEmpty)
                        const Text('No devices detected. Please try again.'),
                      if (bluetoothProvider.scanResults.isNotEmpty)
                        DropdownButton<BluetoothDevice>(
                          value: bluetoothProvider.selectedDevice,
                          onChanged: (device) {
                            setState(() {
                              bluetoothProvider.selectedDevice = device!;
                            });
                          },
                          items: bluetoothProvider.scanResults
                              .map<DropdownMenuItem<BluetoothDevice>>(
                            (result) {
                              BluetoothDevice device = result.device;
                              return DropdownMenuItem<BluetoothDevice>(
                                value: device,
                                child: Row(
                                  children: [
                                    Text(device.platformName),
                                    const SizedBox(width: 8),
                                    Text('RSSI: ${result.rssi}'),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (bluetoothProvider.connected) {
                                          try {
                                            await bluetoothProvider
                                                .disconnectFromDevice(context);
                                            setState(() {
                                              bluetoothProvider.connected =
                                                  false;
                                            });
                                          } catch (error) {
                                            _showErrorDialog(
                                                context,
                                                'Disconnection Error',
                                                'Failed to disconnect from the device.');
                                          }
                                        } else {
                                          try {
                                            await bluetoothProvider
                                                .connectToDevice(
                                                    device, context);
                                            if (bluetoothProvider.connected) {
                                              setState(() {});
                                            }
                                          } catch (error) {
                                            _showErrorDialog(
                                                context,
                                                'Connection Error',
                                                'Failed to connect to the device.');
                                          }
                                        }
                                      },
                                      child: Text(bluetoothProvider.connected
                                          ? 'Disconnect'
                                          : 'Connect'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            bluetoothProvider
                                .scanForDevices(); // Refresh the scan
                          });
                        },
                        child: const Text('Refresh'),
                      ),
                    ],
                  );
                },
              ),
            );
          },
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
