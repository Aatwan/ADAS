import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adas/provider/bluetooth_provider.dart';

class AutoControlView extends StatelessWidget {
  final String title;

  const AutoControlView({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title == 'Obstacle Avoidance'
                        ? 'Obstacle Avoidance'
                        : 'Blind Spot Detection',
                    style: const TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  const Text(
                    'Mode',
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ValueListenableBuilder<String>(
                    valueListenable: Provider.of<BluetoothProvider>(context)
                        .distanceNotifier,
                    builder: (context, distance, child) {
                      return Text(
                        'Obstacle Distance: $distance',
                        style: const TextStyle(fontSize: 25),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable:
                        Provider.of<BluetoothProvider>(context).speedNotifier,
                    builder: (context, speed, child) {
                      return Text(
                        'Speed: $speed',
                        style: const TextStyle(fontSize: 25),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Provider.of<BluetoothProvider>(context, listen: false)
                  .sendMessageToBluetooth('S');
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              textStyle: const TextStyle(fontSize: 25),
            ),
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
