import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_bloc.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_event.dart';
import 'package:demo_pinpad/src/features/agnostiko/presentation/bloc/sdk_state.dart';
import 'package:demo_pinpad/src/core/extensions/context_ext.dart';
import 'package:demo_pinpad/src/test/testing_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String route = "/splash";

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    context.read<SdkBloc>().add(LoadSdkEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final queryData = MediaQuery.of(context);
    final screenWidth = queryData.size.height - 30;
    final screenHeight = queryData.size.width - 30;

    return Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth,
        maxHeight: screenHeight,
      ),
      color: const Color.fromARGB(255, 21, 98, 161),
      child: BlocConsumer<SdkBloc, SdkState>(
        builder: (ctx, state) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/solopago_logo.png",
                    height: 200,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Cargando SDK...",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (ctx, state) {
          if (state is ErrorSdkState) {
            context.showScaffoldMessage(state.message);
          } else if (state is LoadedSdkState) {
            /// SDK loaded.
            ///
            Navigator.pushReplacementNamed(context, TestingMenu.route);
          }
        },
      ),
    );
  }
}
