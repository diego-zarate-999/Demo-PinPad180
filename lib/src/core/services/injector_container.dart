import 'package:demo_pinpad/src/features/agnostiko/data/datasources/sdk_data_source.dart';
import 'package:demo_pinpad/src/features/agnostiko/data/repositories/sdk_repository_impl.dart';
import 'package:demo_pinpad/src/features/agnostiko/domain/repository/sdk_repository.dart';
import 'package:demo_pinpad/src/features/agnostiko/domain/usecases/init_pos.dart';
import 'package:demo_pinpad/src/features/agnostiko/domain/usecases/load_server_certificate.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => LocalSDKDataSource());
  sl.registerLazySingleton<SDKDataSource>(() => sl<LocalSDKDataSource>());
  sl.registerLazySingleton<SDKRepository>(
      () => SDKRepositoryImpl(sl<SDKDataSource>()));
  sl.registerLazySingleton(() => LoadServerCertificate(sl<SDKRepository>()));
  sl.registerLazySingleton(() => InitPOS(sl<SDKRepository>()));

  sl.registerLazySingleton(
    () => SdkBloc(
      loadServerCertificate: sl<LoadServerCertificate>(),
      initPOS: sl<InitPOS>(),
    ),
  );
}
