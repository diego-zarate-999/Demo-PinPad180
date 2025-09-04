import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
import 'package:demo_pinpad/src/core/utils/keypad/keypad.dart';
import 'package:demo_pinpad/src/test/card_test.dart';
import 'package:demo_pinpad/src/test/device_info.dart';
import 'package:demo_pinpad/src/test/protobuffer_test.dart';
import 'package:demo_pinpad/src/test/serialport_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestingMenu extends StatefulWidget {
  static const String route = "/test";

  const TestingMenu({super.key});

  @override
  State<TestingMenu> createState() => _TestingMenuState();
}

class _TestingMenuState extends State<TestingMenu> {
  final _focusNode = FocusNode();

  void _closeApp() {
    SystemNavigator.pop();
  }

  void _handleDigitPressed(int enteredDigit) async {
    Debugger.log("Digit: $enteredDigit");

    switch (enteredDigit) {
      case 1:
        Navigator.of(context).pushNamed(TestCardReader.route);
        break;
      case 2:
        Navigator.of(context).pushNamed(SerialportTest.route);
        break;
      case 3:
        Navigator.of(context).pushNamed(DeviceInfo.route);
        break;
      case 4:
        Navigator.of(context).pushNamed(ReadProtobufferTest.route);
        break;
    }
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
          title: const Text("Pruebas"),
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
                "1. Lectura de Tarjeta.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "2. Comunicación Serial.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "3. Información del Dispositivo.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "4. Recibir Protobuffer.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
