import 'dart:async';

import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:demo_pinpad/src/generated/user.pbgrpc.dart';
import 'package:demo_pinpad/src/serial_port/serialport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  static const String route = '/user-proto';

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String? msg;
  String? name;
  String? address;

  Future<void> _openPort() async {
    final settings = SerialportSettings(
      baudRate: BaudRateType.baud115200,
      dataBits: DataBitsType.data8,
      parityType: ParityType.parNone,
      portType: CommunicationType.usbSerial,
      stopBits: StopBitsType.stop1,
    );

    try {
      SerialPortCommunication.openPort(settings);
      setState(() {
        msg = "Puerto listo.";
      });
    } on SerialPortException catch (error) {
      setState(() {
        msg = "${error.message} code: ${error.errorCode}";
      });
    }
  }

  Future<void> _readPort() async {
    try {
      final data = await SerialPortCommunication.readPort();
      final user = DisplayUserRequest.fromBuffer(data);
      setState(() {
        name = user.name;
        address = user.address;
      });
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
            if (msg != null) Text(msg!),
            if (name != null) const SizedBox(height: 16),
            if (name != null) Text("Name: ${name!}"),
            if (name != null) const SizedBox(height: 16),
            if (address != null) Text("Address: ${address!}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _openPort,
              child: Text(
                "Abrir puerto",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _readPort,
              child: Text(
                "Recibir usuario",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
