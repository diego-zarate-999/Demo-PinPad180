import 'package:agnostiko/agnostiko.dart';
import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
import 'package:demo_pinpad/src/serial_port/serialport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SerialportTest extends StatefulWidget {
  static const String route = "/test/serialport";

  const SerialportTest({super.key});

  @override
  State<SerialportTest> createState() => _SerialportTestState();
}

class _SerialportTestState extends State<SerialportTest> {
  String? _msg;

  Future<void> _openSerialPort() async {
    final settings = SerialportSettings(
      baudRate: BaudRateType.baud115200,
      dataBits: DataBitsType.data8,
      parityType: ParityType.parNone,
      portType: CommunicationType.usbSerial,
      stopBits: StopBitsType.stop1,
    );

    try {
      Debugger.log("Abriendo puerto serial...");
      SerialPortCommunication.openPort(settings);
      Debugger.log("Puerto serial listo!!!");
      setState(() {
        _msg = "Puerto serial abierto";
      });
    } on SerialPortException catch (error) {
      Debugger.log("Error al abrir puerto serial (${error.errorCode})...");
      setState(() {
        _msg = "${error.message} code: ${error.errorCode}";
      });
    }

    Debugger.log("Puerto serial abierto.");
  }

  Future<void> _sendDataToSerial() async {
    Uint8List data = Uint8List.fromList([0x31, 0x32, 0x33]);
    try {
      Debugger.log("Escribiendo en puerto serial...");
      await SerialPortCommunication.writePort(data);
      Debugger.log("Escribiendo en puerto serial exitoso!!");
    } on SerialPortException catch (error) {
      Debugger.log(
          "Error al escribir en puerto serial (${error.errorCode})...");
      setState(() {
        _msg = "${error.message} code: ${error.errorCode}";
      });
    }
  }

  Future<void> _closeSerialPort() async {
    Debugger.log("Cerraando puerto serial...");
    await closeSerial();
    Debugger.log("Puerto serial cerrado!!");
    setState(() {
      _msg = "Puero serial cerrado";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_msg != null)
              Text(
                _msg!,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openSerialPort,
              child: const Text("Abrir puerto serial"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendDataToSerial,
              child: const Text("Enviar datos"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _closeSerialPort,
              child: const Text("Cerrar puerto serial"),
            ),
          ],
        ),
      ),
    );
  }
}
