import 'package:equatable/equatable.dart';

class SerialPortException extends Equatable implements Exception {
  final String message;
  final int errorCode;

  const SerialPortException({
    required this.message,
    required this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class SDKException extends Equatable implements Exception {
  final String message;
  final int errorCode;

  const SDKException({
    required this.errorCode,
    required this.message,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

class EMVPreTransactionException extends Equatable implements Exception {
  final String message;

  const EMVPreTransactionException({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
