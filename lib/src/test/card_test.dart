import 'package:agnostiko/agnostiko.dart';
import 'package:demo_pinpad/src/core/utils/debugger/debugger.dart';
import 'package:flutter/material.dart';

class TestCardReader extends StatefulWidget {
  const TestCardReader({super.key});
  static const String route = "/test/card-reader";

  @override
  State<TestCardReader> createState() => _TestCardReaderState();
}

class _TestCardReaderState extends State<TestCardReader> {
  String? _msg;

  void _onFinishCardDetection() {
    setState(() {
      _msg = "Tarjeta retirada";
    });
  }

  Future<void> _startCardDetection() async {
    final cardStream = openCardReader(cardTypes: [
      CardType.RF,
      CardType.IC,
    ]);

    Debugger.log("Lector de tarjetas abierto.");

    setState(() {
      _msg = "Inserta / Aproxima tarjeta.";
    });

    await for (final event in cardStream) {
      Debugger.log("Tarjeta detectada");
      if (event.cardType == CardType.RF) {
        setState(() {
          _msg = "Tarjeta RF detectada.";
        });
        Debugger.log("Tarjeta RF");
        await waitUntilRFCardRemoved();
        _onFinishCardDetection();
      } else if (event.cardType == CardType.IC) {
        setState(() {
          _msg = "Tarjeta IC detectada.";
        });
        await waitUntilICCardRemoved();
        Debugger.log("Tarjeta IC");
        _onFinishCardDetection();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lectura de tarjeta"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_msg != null)
              Text(
                _msg!,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _startCardDetection,
              child: const Text("Detectar tarjeta"),
            ),
          ],
        ),
      ),
    );
  }
}
