import 'package:flutter/material.dart';

Widget loginScreen({
  required BuildContext context,
  required Function onSubmit,
  required Function onCancel,
  required Function onChangePassword,
  required TextEditingController loginController,
  required TextEditingController passwordController,
  Color? backgroundColor,
  Color? foregroundColor,
  Color? buttonBackgroundColor,
  Color? buttonForegroundColor,
}) {
  backgroundColor ??= Theme.of(context).colorScheme.onSurface;
  foregroundColor ??= Theme.of(context).colorScheme.surface;
  buttonBackgroundColor ??= Theme.of(context).colorScheme.primary;
  buttonForegroundColor ??= Theme.of(context).colorScheme.onPrimary;
  return Scaffold(
    body: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor,
        ),
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hey! Wellcome back, insert your credentials for login",
                style: TextStyle(
                  color: foregroundColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(color: foregroundColor),
                    labelText: "Credentials (User)",
                  ),
                  controller: loginController,
                  style: TextStyle(color: foregroundColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelStyle: TextStyle(color: foregroundColor),
                    labelText: "Password",
                  ),
                  controller: passwordController,
                  style: TextStyle(color: foregroundColor),
                ),
              ),
              TextButton(
                onPressed: () {
                  onChangePassword;
                },
                child: Text(
                  "Recover Password",
                  style: TextStyle(color: foregroundColor),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                          (states) => buttonBackgroundColor as Color),
                    ),
                    onPressed: () {
                      onCancel;
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: buttonForegroundColor),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateColor.resolveWith(
                          (states) => buttonBackgroundColor as Color),
                    ),
                    onPressed: () {
                      onSubmit;
                    },
                    child: Text(
                      "Enter",
                      style: TextStyle(color: buttonForegroundColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
