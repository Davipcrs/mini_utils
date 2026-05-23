import 'package:flutter/material.dart';

// Easy loginScreen for the app with customizable functions for handle userLogin, passwordChange and loginCancel
// Recomended usage inside a SizedBox
Widget loginScreen({
  required BuildContext context,
  required Function onSubmit,
  required Function onCancel,
  required Function onChangePassword,
  required TextEditingController loginController,
  required TextEditingController passwordController,
  Function? onCreateUser,
  Color? backgroundColor,
  Color? foregroundColor,
  Color? buttonBackgroundColor,
  Color? buttonForegroundColor,
  TextStyle? customGreetingTextStyle,
  TextStyle? createUserTextStyle,
  TextStyle? forgetPasswordTextStyle,
  String? customGreetingText,
}) {
  // Constants
  backgroundColor ??= Theme.of(context).colorScheme.surfaceContainer;
  foregroundColor ??= Theme.of(context).colorScheme.onSurface;
  buttonBackgroundColor ??= Theme.of(context).colorScheme.primary;
  buttonForegroundColor ??= Theme.of(context).colorScheme.onPrimary;
  customGreetingText ??=
      "Hey! Wellcome back, insert your credentials for login";
  customGreetingTextStyle ??= TextStyle(color: foregroundColor, fontSize: 23);
  forgetPasswordTextStyle ??= TextStyle(color: foregroundColor);
  createUserTextStyle ??= TextStyle(color: foregroundColor);

  bool isObscured = true;

  return StatefulBuilder(
    builder: (BuildContext context, void Function(void Function()) setState) {
      return Scaffold(
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset:
                      const Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
              color: backgroundColor,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      customGreetingText!,
                      style: customGreetingTextStyle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 16.0, right: 16.0),
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
                    padding: const EdgeInsets.only(
                        bottom: 16.0, left: 16.0, right: 16.0),
                    child: TextField(
                      obscureText: isObscured,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelStyle: TextStyle(
                          color: foregroundColor,
                        ),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscured
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscured = !isObscured;
                            });
                          },
                        ),
                      ),
                      controller: passwordController,
                      style: TextStyle(color: foregroundColor),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      onCreateUser != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: TextButton(
                                onPressed: () {
                                  onCreateUser();
                                },
                                child: Text(
                                  "Create User",
                                  style: createUserTextStyle,
                                ),
                              ),
                            )
                          : const SizedBox
                              .shrink(), // Create Button only if the function is defined
                      TextButton(
                        onPressed: () {
                          onChangePassword();
                        },
                        child: Text(
                          "Recover Password",
                          style: forgetPasswordTextStyle,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateColor.resolveWith(
                                  (states) => buttonBackgroundColor as Color),
                            ),
                            onPressed: () {
                              onCancel();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: buttonForegroundColor),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateColor.resolveWith(
                                (states) => buttonBackgroundColor as Color),
                          ),
                          onPressed: () {
                            onSubmit();
                          },
                          child: Text(
                            "Enter",
                            style: TextStyle(color: buttonForegroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
