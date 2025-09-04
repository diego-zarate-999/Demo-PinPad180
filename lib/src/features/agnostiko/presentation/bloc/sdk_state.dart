import 'package:equatable/equatable.dart';

abstract class SdkState extends Equatable {
  const SdkState();

  @override
  List<Object> get props => [];
}

final class SdkInitial extends SdkState {}

class LoadingSdkState extends SdkState {}

class LoadedSdkState extends SdkState {}

class ErrorSdkState extends SdkState {
  final String message;
  final int errorCode;
  const ErrorSdkState(this.message, this.errorCode);
}
