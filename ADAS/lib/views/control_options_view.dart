import 'package:adas/app_localizations.dart';
import 'package:adas/provider/bluetooth_provider.dart';
import 'package:adas/views/auto_control_view.dart';
import 'package:adas/views/manual_control_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlOptionsView extends StatelessWidget {
  const ControlOptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text(
          AppLocalizations.of(context).translate('control'),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<BluetoothProvider>(
          builder: (context, bluetoothProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    bluetoothProvider.sendMessageToBluetooth('O');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AutoControlView(
                          title: 'Obstacle Avoidance',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child:
                      Text(AppLocalizations.of(context).translate('obstacle')),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    bluetoothProvider.sendMessageToBluetooth('D');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AutoControlView(
                          title: 'Blind Spot Detection',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child:
                      Text(AppLocalizations.of(context).translate('blindspot')),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManualControlView(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: Text(AppLocalizations.of(context).translate('manual')),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
