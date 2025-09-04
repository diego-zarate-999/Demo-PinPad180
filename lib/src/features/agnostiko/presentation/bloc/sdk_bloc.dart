import 'dart:io';

import 'package:agnostiko/device/src/device.dart';
import 'package:bloc/bloc.dart';
import 'package:demo_pinpad/src/features/agnostiko/domain/usecases/init_pos.dart';
import 'package:demo_pinpad/src/features/agnostiko/domain/usecases/load_server_certificate.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_event.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_state.dart';
import 'package:demo_pinpad/src/core/error/failure.dart';

class SdkBloc extends Bloc<SdkEvent, SdkState> {
  final LoadServerCertificate loadServerCertificate;
  final InitPOS initPOS;

  SdkBloc({required this.loadServerCertificate, required this.initPOS})
      : super(SdkInitial()) {
    on<LoadSdkEvent>(_loadSdkHandler);
  }

  Future<void> _loadSdkHandler(
      LoadSdkEvent event, Emitter<SdkState> emit) async {
    emit(LoadingSdkState());

    /// Cargar el certificado
    ///

    if (Platform.isLinux) {
      await loadServerCertificate();
    }

    await Future.delayed(const Duration(seconds: 2));

    /// Cargar el SDK
    ///
    final response = await initPOS();
    return response.fold(
      (Failure failure) =>
          emit(ErrorSdkState(failure.message, failure.errorCode)),
      (isLoaded) async {
        /// La carga ha sido completada
        ///
        await beep(500, 300);
        await beep(750, 300);
        await beep(1000, 300);

        emit(LoadedSdkState());
      },
    );
  }
}
