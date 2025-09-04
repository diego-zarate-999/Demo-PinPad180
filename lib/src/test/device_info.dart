import 'dart:io';

import 'package:agnostiko/device/device.dart';
import 'package:flutter/material.dart';

class DeviceInfo extends StatefulWidget {
  const DeviceInfo({super.key});
  static const String route = "/test/device-info";

  @override
  State<DeviceInfo> createState() {
    return _DeviceInfoState();
  }
}

class _DeviceInfoState extends State<DeviceInfo> {
  late String? _serialNumber;
  late String _brand;
  late DeviceType _deviceType;
  late Directory _appDirectory;
  late PlatformInfo _platformInfo;

  bool loading = true;

  Future<void> _loadTerminalData() async {
    _serialNumber = await getSerialNumber();
    _deviceType = await getDeviceType();
    _brand = (await getPlatformInfo()).deviceBrand;
    _appDirectory = await getApplicationDocumentsDirectory();
    _platformInfo = await getPlatformInfo();
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTerminalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información PinPad"),
      ),
      body: Scaffold(
        body: Center(
            child: Column(
          children: [
            if (loading)
              Text(
                "Cargando..",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            if (!loading)
              Text(
                _serialNumber ?? "NO",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            if (!loading)
              Text(
                _brand,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            if (!loading)
              Text(
                _deviceType.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            if (!loading)
              Text(
                _appDirectory.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            if (!loading)
              Text(
                _platformInfo.hasCardReader.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
          ],
        )),
      ),
    );
  }
}
