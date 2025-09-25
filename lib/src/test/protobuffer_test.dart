import 'dart:async';

import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:demo_pinpad/src/generated/user.pbgrpc.dart';
import 'package:demo_pinpad/src/serial_port/serialport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadProtobufferTest extends StatefulWidget {
  const ReadProtobufferTest({super.key});

  static const String route = '/test/read-protobuffer';

  @override
  State<ReadProtobufferTest> createState() => _ReadProtobufferTestState();
}

class _ReadProtobufferTestState extends State<ReadProtobufferTest> {
  String? msg;
  String? name;
  String? address;

  late Stream<SerialPortEvent> _serialStream;

  Future<void> _openPort() async {
    final settings = SerialportSettings(
      communicationType: CommunicationType.usbSerial,
      baudRate: BaudRateType.baud115200,
      dataBits: DataBitsType.data8,
      parityType: ParityType.parNone,
      portType: CommunicationType.usbSerial,
      stopBits: StopBitsType.stop1,
    );

    try {
      _serialStream = SerialPort().open(settings);
      setState(() {
        msg = "Puerto listo. Esperando protobuffer...";
      });

      await for (final event in _serialStream) {
        final data = event.data;
        final user = DisplayUserRequest.fromBuffer(data);

        setState(() {
          name = user.name;
          address = user.address;
        });
      }
    } on SerialPortException catch (error) {
      setState(() {
        msg = "${error.message} code: ${error.errorCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Protobuffer"),
        actions: [
          IconButton(
            onPressed: () async {
              SystemNavigator.pop();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            if (msg != null)
              Text(
                msg!,
                textAlign: TextAlign.center,
              ),
            if (name != null) const SizedBox(height: 16),
            if (name != null)
              Text(
                "Name: ${name!}",
                textAlign: TextAlign.center,
              ),
            if (name != null) const SizedBox(height: 16),
            if (address != null)
              Text(
                "Address: ${address!}",
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openPort,
                child: Text(
                  "Abrir puerto",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
