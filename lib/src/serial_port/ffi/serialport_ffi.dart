import 'dart:ffi';

import 'package:demo_pinpad/src/serial_port/ffi/utils/typedef.dart';
import 'package:ffi/ffi.dart';

sealed class PortSettings extends Struct {
  @Int32()
  external int baudRate;

  @Int32()
  external int dataBits;

  @Int32()
  external int stopBits;

  @Int32()
  external int parity;
}

abstract class SerialportFFI {
  int sysGetInfo(int infoID, Pointer<Utf8> outBuf, Pointer<Int32> outBufLen);

  int portOpen(int portType, Pointer<PortSettings> settings);
  int portFlush(int portType);
  int portWrite(int portType, Pointer<Uint8> buf, int len);
  int portReadLen(int portType, Pointer<Int32> outLen);
  int portRead(
      int portType, Pointer<Uint8> buf, Pointer<Int32> bufLen, int timeout);
  int portClose(int portType);
}

class SerialportFFIImpl implements SerialportFFI {
  final DynamicLibrary serialportNative;

  late final SysGetInfo _getInfo;
  late final PortOpen _openPort;
  late final PortFlush _flushPort;
  late final PortWrite _writePort;
  late final PortReadLen _readLenPort;
  late final PortRead _readPort;
  late final PortClose _closePort;

  SerialportFFIImpl._(this.serialportNative) {
    _bindLookups();
  }

  static Future<SerialportFFIImpl> build() async {
    try {
      final lib = DynamicLibrary.open("libserial_wrapper.so");

      return SerialportFFIImpl._(lib);
    } catch (e) {
      throw Exception('Error al abrir wrapper.');
    }
  }

  @override
  int portClose(int portType) => _closePort(portType);

  @override
  int portFlush(int portType) => _flushPort(portType);

  @override
  int portOpen(int portType, Pointer<PortSettings> settings) =>
      _openPort(portType, settings);

  @override
  int portRead(int portType, Pointer<Uint8> buf, Pointer<Int32> bufLen,
          int timeout) =>
      _readPort(portType, buf, bufLen, timeout);

  @override
  int portReadLen(int portType, Pointer<Int32> outLen) =>
      _readLenPort(portType, outLen);

  @override
  int portWrite(int portType, Pointer<Uint8> buf, int len) =>
      _writePort(portType, buf, len);

  @override
  int sysGetInfo(int infoID, Pointer<Utf8> outBuf, Pointer<Int32> outBufLen) =>
      _getInfo(infoID, outBuf, outBufLen);

  void _bindLookups() {
    _getInfo =
        serialportNative.lookupFunction<native_sys_get_info_func, SysGetInfo>(
            'wrapper_SysGetInfo');
    _openPort = serialportNative
        .lookupFunction<native_port_open_func, PortOpen>('wrapper_PortOpen');

    _flushPort = serialportNative
        .lookupFunction<native_port_flush_func, PortFlush>('wrapper_PortFlush');

    _writePort = serialportNative
        .lookupFunction<native_port_write_func, PortWrite>('wrapper_PortWrite');

    _readLenPort =
        serialportNative.lookupFunction<native_port_readlen_func, PortReadLen>(
            'wrapper_PortReadLen');

    _readPort = serialportNative
        .lookupFunction<native_port_read_func, PortRead>('wrapper_PortRead');

    _closePort = serialportNative
        .lookupFunction<native_port_close_func, PortClose>('wrapper_PortClose');
  }
}
