import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
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

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        Debugger.log("Tecla presionada: ${event.character}");
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pruebas"),
          actions: [
            IconButton(onPressed: _closeApp, icon: const Icon(Icons.logout)),
          ],
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("1. Lectura de Tarjeta."),
                  onPressed: () {
                    Navigator.of(context).pushNamed(TestCardReader.route);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("2. Comunicación Serial."),
                  onPressed: () {
                    Navigator.of(context).pushNamed(SerialportTest.route);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("3. Información del Dispositivo."),
                  onPressed: () {
                    Navigator.of(context).pushNamed(DeviceInfo.route);
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text("4. Recibir Protobuffer."),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ReadProtobufferTest.route);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
