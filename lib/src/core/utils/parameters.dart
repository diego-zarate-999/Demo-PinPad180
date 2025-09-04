import 'dart:convert';
import 'dart:io';

import 'package:agnostiko/device/src/device.dart';
import 'package:agnostiko/emv/src/capk.dart';
import 'package:agnostiko/emv/src/emv_app.dart';
import 'package:agnostiko/emv/src/terminal_parameters.dart';
import 'package:flutter/services.dart';

const _defaultPath = "assets/params";
const _paramsFilename = "terminal_parameters.json";
const _aidFilename = "aid.json";
const _capkFilename = "capk.json";

/// Carga los parámetros de terminal configurados en un archivo JSON de la app.
Future<TerminalParameters> loadTerminalParameters() async {
  String jsonStr = "";
  try {
    final externalPath = (await getApplicationDocumentsDirectory()).path;
    final file = File('$externalPath/$_paramsFilename');

    jsonStr = await file.readAsString();
  } catch (e) {
    jsonStr = await rootBundle.loadString("$_defaultPath/$_paramsFilename");
  }

  return TerminalParameters.fromJson(jsonDecode(jsonStr));
}

/// Carga la lista de apps EMV y sus parámetros asociados por cada AID.
Future<List<EmvApp>> loadEmvAppList() async {
  String jsonStr = "";

  // Si falla la carga del archivo...
  try {
    final externalPath = (await getApplicationDocumentsDirectory()).path;
    final file = File('$externalPath/$_aidFilename');

    jsonStr = await file.readAsString();
  } catch (e) {
    // ...utilizamos los valores por defecto.
    jsonStr = await rootBundle.loadString("$_defaultPath/$_aidFilename");
  }

  return parseEmvAppList(jsonStr);
}

List<EmvApp> parseEmvAppList(String jsonData) {
  final resList = jsonDecode(jsonData) as List;
  return resList.map((app) => EmvApp.fromJson(app)).toList();
}

/// Carga la lista de llaves públicas (CAPK) para aplicaciones EMV.
Future<List<CAPK>> loadCAPKList() async {
  String jsonStr = "";

  // Si falla la carga del archivo...
  try {
    final externalPath = (await getApplicationDocumentsDirectory()).path;
    final file = File('$externalPath/$_capkFilename');

    jsonStr = await file.readAsString();
  } catch (e) {
    // ...utilizamos los valores por defecto.
    jsonStr = await rootBundle.loadString("$_defaultPath/$_capkFilename");
  }

  return CAPK.parseJsonArray(jsonStr);
}
