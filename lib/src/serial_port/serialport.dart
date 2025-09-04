import 'dart:ffi';
import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:ffi/ffi.dart';

import 'package:demo_pinpad/src/serial_port/ffi/serialport_ffi.dart';

enum CommunicationType {
  rs232,
  pinpad,
  wireless,
  usbSerial,
  usbHost,
  usbHostHid,
  usbHostPrinter,
}

extension PortTypeValue on CommunicationType {
  int get value {
    switch (this) {
      case CommunicationType.rs232:
        return 0;
      case CommunicationType.pinpad:
        return 1;
      case CommunicationType.wireless:
        return 2;
      case CommunicationType.usbSerial:
        return 8;
      case CommunicationType.usbHost:
        return 10;
      case CommunicationType.usbHostHid:
        return 12;
      case CommunicationType.usbHostPrinter:
        return 13;
    }
  }
}

enum BaudRateType {
  baud9600,
  baud19200,
  baud38400,
  baud57600,
  baud115200,
}

extension BaudRateTypeValue on BaudRateType {
  int get value {
    switch (this) {
      case BaudRateType.baud9600:
        return 9600;
      case BaudRateType.baud19200:
        return 19200;
      case BaudRateType.baud38400:
        return 38400;
      case BaudRateType.baud57600:
        return 57600;
      case BaudRateType.baud115200:
        return 115200;
    }
  }
}

enum DataBitsType {
  data5,
  data6,
  data7,
  data8,
}

extension DataBitsTypeValue on DataBitsType {
  int get value {
    switch (this) {
      case DataBitsType.data5:
        return 5;
      case DataBitsType.data6:
        return 6;
      case DataBitsType.data7:
        return 7;
      case DataBitsType.data8:
        return 8;
    }
  }
}

enum StopBitsType {
  stop1,
  stop2,
}

enum ParityType {
  parNone,
  parOdd,
  parEven,
}

class SerialportSettings {
  final BaudRateType baudRate;
  final DataBitsType dataBits;
  final StopBitsType stopBits;
  final ParityType parityType;
  final CommunicationType portType;

  SerialportSettings({
    required this.baudRate,
    required this.dataBits,
    required this.stopBits,
    required this.parityType,
    required this.portType,
  });
}

class SerialPortCommunication {
  final SerialportSettings _serialPortSettings;
  late final SerialportFFI _serialportFFI;

  Pointer<PortSettings>? _portSettings;

  static SerialPortCommunication? _instance;

  SerialPortCommunication._internal(this._serialPortSettings);

  /// Funciones disponibles por usuarios
  /// de la clase.
  ///

  static Future<void> openPort(SerialportSettings settings) async {
    if (_instance == null) {
      final singleton = SerialPortCommunication._internal(settings);
      singleton._serialportFFI = await SerialportFFIImpl.build();
      _instance = singleton;
    }

    await _instance!._openPortInternal();
  }

  static Future<void> closePort() async {
    if (_instance != null) {
      await _instance!._closePortInternal();
      _instance = null;
    }
  }

  static Future<void> writePort(List<int> data) async {
    if (_instance == null) {
      throw SerialPortException(
        message: "Puerto no inicializado. Llama a [openPort] primero.",
        errorCode: -1,
      );
    }
    await _instance!._writePortInternal(data);
  }

  static Future<List<int>> readPort({
    int bufferSize = 256,
    int timeoutMs = 5000,
  }) async {
    if (_instance == null) {
      throw SerialPortException(
        message: "Puerto no inicializado. Llama a [openPort] primero.",
        errorCode: -1,
      );
    }
    return await _instance!._readPortInternal(
      bufferSize: bufferSize,
      timeoutMs: timeoutMs,
    );
  }

  /// Funciones internas.
  ///
  ///

  Future<void> _openPortInternal() async {
    _portSettings = calloc<PortSettings>();
    _portSettings!.ref
      ..baudRate = _serialPortSettings.baudRate.value
      ..dataBits = _serialPortSettings.dataBits.value
      ..stopBits = _serialPortSettings.stopBits.index
      ..parity = _serialPortSettings.parityType.index;

    final result = _serialportFFI.portOpen(
      _serialPortSettings.portType.value,
      _portSettings!,
    );

    if (result != 0) {
      calloc.free(_portSettings!);
      _portSettings = null;
      throw SerialPortException(
        message: "Error al abrir el puerto serial.",
        errorCode: result,
      );
    }
  }

  Future<void> _closePortInternal() async {
    final result = _serialportFFI.portClose(_serialPortSettings.portType.value);
    if (result != 0) {
      throw SerialPortException(
        message: "Error al cerrar el puerto serial.",
        errorCode: result,
      );
    }

    if (_portSettings != null) {
      calloc.free(_portSettings!);
      _portSettings = null;
    }
  }

  Future<void> _writePortInternal(List<int> data) async {
    if (_portSettings == null) {
      throw SerialPortException(
        message: "Puerto serial no abierto",
        errorCode: -1,
      );
    }

    final buf = calloc<Uint8>(data.length);

    try {
      for (int i = 0; i < data.length; i++) {
        buf[i] = data[i];
      }

      final result = _serialportFFI.portWrite(
        _serialPortSettings.portType.value,
        buf,
        data.length,
      );

      _serialportFFI.portFlush(_serialPortSettings.portType.value);

      if (result != 0) {
        throw SerialPortException(
          message: "Error al enviar datos por el puerto serial.",
          errorCode: result,
        );
      }
    } finally {
      calloc.free(buf);
    }
  }

  Future<List<int>> _readPortInternal({
    int bufferSize = 256,
    int timeoutMs = 5000,
  }) async {
    final buf = calloc<Uint8>(bufferSize);
    final lenPtr = calloc<Int32>()..value = bufferSize;

    try {
      final result = _serialportFFI.portRead(
        _serialPortSettings.portType.value,
        buf,
        lenPtr,
        timeoutMs,
      );

      if (result != 0) {
        throw SerialPortException(
          message: "Error al leer del puerto serial.",
          errorCode: result,
        );
      }

      final bytesRead = lenPtr.value;
      if (bytesRead <= 0) return [];

      return List<int>.generate(bytesRead, (i) => buf[i]);
    } finally {
      calloc.free(buf);
      calloc.free(lenPtr);
    }
  }
}
