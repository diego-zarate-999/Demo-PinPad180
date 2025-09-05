import 'package:demo_pinpad/src/core/route_observer/route_observer.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_bloc.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/screens/splash_screen.dart';
import 'package:demo_pinpad/src/core/services/injector_container.dart';
import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
import 'package:demo_pinpad/src/test/card_test.dart';
import 'package:demo_pinpad/src/test/device_info.dart';
import 'package:demo_pinpad/src/test/protobuffer_test.dart';
import 'package:demo_pinpad/src/test/serialport_comm_menu.dart';
import 'package:demo_pinpad/src/test/testing_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  ///
  /// Inicializar clase para los logs.
  ///
  await Debugger.init();

  Debugger.log("=========== Aplicación iniciada ===========");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SdkBloc>()),
      ],
      child: MaterialApp(
        initialRoute: SplashScreen.route,
        navigatorObservers: [routeObserver],
        routes: {
          SplashScreen.route: (context) => const SplashScreen(),
          TestingMenu.route: (context) => const TestingMenu(),
          DeviceInfo.route: (context) => const DeviceInfo(),
          TestCardReader.route: (context) => const TestCardReader(),
          SerialportCommMenu.route: (context) => const SerialportCommMenu(),
          ReadProtobufferTest.route: (context) => const ReadProtobufferTest(),
        },
      ),
    ),
  );
}
