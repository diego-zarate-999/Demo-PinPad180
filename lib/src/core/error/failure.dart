import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int errorCode;

  const Failure({
    required this.message,
    required this.errorCode,
  });

  String get errorMessage => message;
}

class SerialPortFailure extends Failure {
  const SerialPortFailure({
    required super.message,
    required super.errorCode,
  });

  @override
  List<Object?> get props => [message];
}

class SDKFailure extends Failure {
  const SDKFailure({
    required super.message,
    required super.errorCode,
  });

  @override
  List<Object?> get props => [message];
}
