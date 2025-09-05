import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
import 'package:demo_pinpad/src/core/utils/keypad/keypad.dart';
import 'package:demo_pinpad/src/serial_port/serialport.dart';
import 'package:demo_pinpad/src/test/serialport_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SerialportCommMenu extends StatefulWidget {
  static const String route = "/test-seriaport-menu";

  const SerialportCommMenu({super.key});

  @override
  State<SerialportCommMenu> createState() => _SerialportCommMenuState();
}

class _SerialportCommMenuState extends State<SerialportCommMenu> {
  final _focusNode = FocusNode();

  void _closeApp() {
    SystemNavigator.pop();
  }

  void _handleDigitPressed(int enteredDigit) async {
    Debugger.log("Digit: $enteredDigit");

    CommunicationType selectedCommType;
    switch (enteredDigit) {
      case 1:
        selectedCommType = CommunicationType.pinpad;
        break;
      case 2:
        selectedCommType = CommunicationType.rs232;
        break;
      case 3:
        selectedCommType = CommunicationType.usbHost;
        break;
      case 4:
        selectedCommType = CommunicationType.usbHostHid;
        break;
      case 5:
        selectedCommType = CommunicationType.usbSerial;
        break;
      default:
        return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SerialportTest(
          communicationType: selectedCommType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: rawKeypadHandler(
        context,
        onEscape: _closeApp,
        onDigit: _handleDigitPressed,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Tipo de Puerto"),
          actions: [
            IconButton(
              onPressed: _closeApp,
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "1. PINPAD.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "2. RS232.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "3. USB HOST.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "4. USB HOST HID.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "5. USB SERIAL.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
