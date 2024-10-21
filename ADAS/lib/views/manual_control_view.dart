import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adas/provider/bluetooth_provider.dart';

class ManualControlView extends StatefulWidget {
  const ManualControlView({super.key});

  @override
  ManualControlViewState createState() => ManualControlViewState();
}

class ManualControlViewState extends State<ManualControlView> {
  Timer? _timer;
  String? _selectedSpeed;

  void _startSendingMessage(String message) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      Provider.of<BluetoothProvider>(context, listen: false)
          .sendMessageToBluetooth(message);
    });
  }

  void _stopSendingMessage() {
    _timer?.cancel();
  }

  void _setSelectedSpeed(String speed) {
    setState(() {
      _selectedSpeed = speed;
    });
    Provider.of<BluetoothProvider>(context, listen: false)
        .sendMessageToBluetooth(speed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Manual Control Mode',
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 40),
          ArrowButton(
            arrowIcon: const Icon(
              Icons.arrow_upward,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Provider.of<BluetoothProvider>(context, listen: false)
                  .sendMessageToBluetooth('F');
            },
            onHold: () {
              _startSendingMessage('F');
            },
            onRelease: _stopSendingMessage,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ArrowButton(
                arrowIcon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Provider.of<BluetoothProvider>(context, listen: false)
                      .sendMessageToBluetooth('L');
                },
                onHold: () {
                  _startSendingMessage('L');
                },
                onRelease: _stopSendingMessage,
              ),
              ArrowButton(
                arrowIcon: const Icon(
                  Icons.stop,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Provider.of<BluetoothProvider>(context, listen: false)
                      .sendMessageToBluetooth('S');
                },
                onHold: () {},
                onRelease: () {},
              ),
              ArrowButton(
                arrowIcon: const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  Provider.of<BluetoothProvider>(context, listen: false)
                      .sendMessageToBluetooth('R');
                },
                onHold: () {
                  _startSendingMessage('R');
                },
                onRelease: _stopSendingMessage,
              ),
            ],
          ),
          ArrowButton(
            arrowIcon: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              Provider.of<BluetoothProvider>(context, listen: false)
                  .sendMessageToBluetooth('B');
            },
            onHold: () {
              _startSendingMessage('B');
            },
            onRelease: _stopSendingMessage,
          ),
          const SizedBox(height: 40),
          const Text(
            'Set Car Speed',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          PowerGauge(
            selectedSpeed: _selectedSpeed,
            onSpeedSelected: _setSelectedSpeed,
          ),
        ],
      ),
    );
  }
}

class ArrowButton extends StatefulWidget {
  final Icon arrowIcon;
  final VoidCallback onPressed;
  final VoidCallback onHold;
  final VoidCallback onRelease;

  const ArrowButton({
    super.key,
    required this.arrowIcon,
    required this.onPressed,
    required this.onHold,
    required this.onRelease,
  });

  @override
  ArrowButtonState createState() => ArrowButtonState();
}

class ArrowButtonState extends State<ArrowButton> {
  bool _isPressed = false;

  void _handlePressStart() {
    setState(() {
      _isPressed = true;
    });
    widget.onHold();
  }

  void _handlePressEnd() {
    setState(() {
      _isPressed = false;
    });
    widget.onRelease();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onLongPressStart: (_) => _handlePressStart(),
      onLongPressEnd: (_) => _handlePressEnd(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipOval(
          child: Material(
            color: _isPressed ? Colors.red : Colors.blue, // Button color
            child: InkWell(
              splashColor: Colors.red, // Splash color
              onTap: widget.onPressed,
              child: SizedBox(width: 80, height: 80, child: widget.arrowIcon),
            ),
          ),
        ),
      ),
    );
  }
}

class PowerGauge extends StatelessWidget {
  final String? selectedSpeed;
  final ValueChanged<String> onSpeedSelected;

  const PowerGauge({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PowerGaugeButton(
          label: 'Min',
          message: 'Q',
          isSelected: selectedSpeed == 'Q',
          onSelected: onSpeedSelected,
        ),
        PowerGaugeButton(
          label: '1',
          message: 'W',
          isSelected: selectedSpeed == 'W',
          onSelected: onSpeedSelected,
        ),
        PowerGaugeButton(
          label: '2',
          message: 'X',
          isSelected: selectedSpeed == 'X',
          onSelected: onSpeedSelected,
        ),
        PowerGaugeButton(
          label: '3',
          message: 'Y',
          isSelected: selectedSpeed == 'Y',
          onSelected: onSpeedSelected,
        ),
        PowerGaugeButton(
          label: 'Max',
          message: 'U',
          isSelected: selectedSpeed == 'U',
          onSelected: onSpeedSelected,
        ),
      ],
    );
  }
}

class PowerGaugeButton extends StatelessWidget {
  final String label;
  final String message;
  final bool isSelected;
  final ValueChanged<String> onSelected;

  const PowerGaugeButton({
    super.key,
    required this.label,
    required this.message,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(message);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: isSelected ? Colors.red : Colors.blue, // Button color
            child: InkWell(
              onTap: () {
                onSelected(message);
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
