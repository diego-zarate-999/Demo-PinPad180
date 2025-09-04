import 'dart:convert';
import 'dart:io';

import 'package:agnostiko/agnostiko.dart';
import 'package:demo_pinpad/src/core/error/exception.dart';
import 'package:demo_pinpad/src/core/utils/token.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';

abstract class SDKDataSource {
  Future<SecurityContext> loadServerCertificate();
  Future<Uint8List> getTokenOnline(String serialNumber, String brand);
  Future<Uint8List?> initToken();
  Future<void> initPos();
}

class LocalSDKDataSource implements SDKDataSource {
  @override
  Future<Uint8List> getTokenOnline(String brand, String serialNumber) async {
    String baseUrl = "https://tms-server-demo.apps2go.tech";

    const version = "2";
    const appId = "agnostiko_example";

    try {
      final dio = Dio();

      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;

      final response = await dio.get(
        '$baseUrl/token/$brand/${serialNumber.toUpperCase()}?version=$version&app=$appId',
      );

      if (response.statusCode == 200) {
        String token = response.data;
        final authToken = base64Decode(token);

        saveToken(authToken.toHexStr());

        return authToken;
      }

      throw SDKException(
        message: "Error al obtener token.",
        errorCode: response.statusCode ?? 600,
      );
    } on DioException catch (error) {
      throw SDKException(
        message: error.message ?? "Error al obtener token",
        errorCode: error.response!.statusCode ?? 500,
      );
    } on SDKException catch (_) {
      rethrow;
    }
  }

  Future<Uint8List?> _getLocalToken() async {
    Uint8List? token;
    try {
      token = await checkToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> initPos() async {
    Uint8List? authToken;
    final deviceType = await getDeviceType();

    try {
      if (deviceType == DeviceType.POS) {
        authToken = await initToken();

        await initSDK(authToken: authToken);
      } else if (deviceType == DeviceType.PINPAD) {
        ///
        /// TODO: Verificar conexion bluethooth.
        ///

        await connectPinpad();

        authToken = await initToken();
        await initSDK(authToken: authToken);
      } else {
        throw const SDKException(
          message: "Dispositivo no soportado.",
          errorCode: 2,
        );
      }
    } on SDKException {
      rethrow;
    } on PlatformException catch (e) {
      throw SDKException(
        message: e.toString(),
        errorCode: 3,
      );
    } catch (_) {
      throw const SDKException(
        message: "Error al inicializar POS.",
        errorCode: 4,
      );
    }
  }

  @override
  Future<Uint8List?> initToken() async {
    Uint8List authToken;
    try {
      Uint8List? token = await _getLocalToken();

      if (token != null) {
        bool isTokenExpired = _validateExpDateToken(token);
        if (isTokenExpired) {
          return null;
        }

        return token;
      }

      final brand = (await getPlatformInfo()).deviceBrand;
      final serialNumber = await getSerialNumber();
      if (serialNumber != null) {
        authToken = await getTokenOnline(brand, serialNumber);
        return authToken;
      }

      throw const SDKException(
        errorCode: 5,
        message: "Error al obtener token online.",
      );
    } on SDKException {
      rethrow;
    } catch (e) {
      throw const SDKException(
        message: "Error al inicializar el token.",
        errorCode: 5,
      );
    }
  }

  @override
  Future<SecurityContext> loadServerCertificate() async {
    try {
      ByteData data = await rootBundle.load(
        'assets/ca/insightone-server.agnostiko.cer',
      );
      SecurityContext context = SecurityContext(withTrustedRoots: false);
      context.setTrustedCertificatesBytes(data.buffer.asUint8List());
      return context;
    } catch (error) {
      throw const SDKException(
          errorCode: 100, message: "Error al cargar certificado.");
    }
  }

  bool _validateExpDateToken(Uint8List authToken) {
    try {
      if (authToken.length >= 263) {
        final expDateHex = authToken.sublist(257, 263);
        final expDateStr = expDateHex.toHexStr();
        final expDateToken = int.parse(expDateStr, radix: 16);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        return expDateToken < timestamp;
      } else {
        return true;
      }
    } catch (e) {
      return true;
    }
  }
}
