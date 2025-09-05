import 'dart:convert';

import 'package:agnostiko/agnostiko.dart';
import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
import 'package:demo_pinpad/src/serial_port/serialport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SerialportTest extends StatefulWidget {
  static const String route = "/test/serialport";

  const SerialportTest({super.key, required this.communicationType});

  final CommunicationType communicationType;

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
      portType: widget.communicationType,
      stopBits: StopBitsType.stop1,
    );

    try {
      Debugger.log("Abriendo puerto serial...");
      SerialPortCommunication.openPort(settings);
      Debugger.log("Puerto serial listo!!!");
      setState(() {
        _msg = "Abierto como: ${widget.communicationType.name}";
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
    Utf8Encoder encoder = Utf8Encoder();
    Uint8List data = encoder.convert(widget.communicationType.name);

    try {
      Debugger.log("Escribiendo en puerto serial: ${data.toString()}");
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
    Debugger.log("Cerrando puerto serial...");
    await closeSerial();
    Debugger.log("Puerto serial cerrado!!");
    setState(() {
      _msg = "Puerto serial cerrado";
    });
  }

  Future<void> _readSerialPort() async {
    try {
      setState(() {
        _msg = "Leyendo puerto serial...";
      });
      final data = await SerialPortCommunication.readPort();
      setState(() {
        _msg = "Recibido: ${data.toString()}";
      });
    } on SerialPortException catch (error) {
      setState(() {
        _msg = "${error.message} code: ${error.errorCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.communicationType.name),
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
              onPressed: _readSerialPort,
              child: const Text("Leer puerto serial"),
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
