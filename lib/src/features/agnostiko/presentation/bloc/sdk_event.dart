import 'package:equatable/equatable.dart';

abstract class SdkEvent extends Equatable {
  const SdkEvent();

  @override
  List<Object> get props => [];
}

class LoadSdkEvent extends SdkEvent {}
