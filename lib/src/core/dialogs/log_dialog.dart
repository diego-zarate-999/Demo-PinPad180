import 'package:flutter/material.dart';

Future<void> showLogDialog(
  BuildContext context, {
  required void Function() onClose,
  required String title,
  required List<Widget> content,
  required String buttonText,
}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: const Color.fromARGB(255, 40, 40, 40),
            actionsOverflowButtonSpacing: 1,
            actionsPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            title: Center(
                child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            content: SizedBox(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: content,
                  ),
                ),
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onClose();
                },
                child: Text(buttonText),
              ),
            ],
          ),
        );
      });
}
