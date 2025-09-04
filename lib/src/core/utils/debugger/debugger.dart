import 'dart:io';

import 'package:agnostiko/device/device.dart';

///
/// Singleton para mandar los logs.
///

class Debugger {
  static final Debugger _instance = Debugger._internal();
  factory Debugger() => _instance;
  Debugger._internal();

  static late File _logFile;
  static const String _logFileName = "LOGSS";

  static Future<void> init({String logFileName = _logFileName}) async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    final logFilePath = "$dir/$logFileName";
    _logFile = File(logFilePath);

    if (!await _logFile.exists()) {
      await _logFile.create(recursive: true);
    }

    await _logFile.writeAsString(
      "\n\n=== Pinpad Logs ===\n\n",
      mode: FileMode.write,
      flush: true,
    );
  }

  static void log(String message) {
    _logFile.writeAsStringSync(
      "$message\n",
      mode: FileMode.append,
      flush: true,
    );
  }
}
