import 'dart:async';

import 'package:flutter/material.dart';

Widget digitalClock({required BuildContext context, TextStyle? style}) {
  TimeOfDay time = TimeOfDay.now();
  String? hour;
  String? minute;
  style ??= const TextStyle();
  return StatefulBuilder(
    builder: (context, setState) {
      correctTime() {
        if (time.hour < 10) {
          hour = "0${time.hour}";
        } else {
          hour = time.hour.toString();
        }
        if (time.minute < 10) {
          minute = "0${time.minute}";
        } else {
          minute = time.minute.toString();
        }
      }

      correctTime();
      resetTime() {
        if (TimeOfDay.now() == time) {
          return;
        }
        setState(
          () {
            time = TimeOfDay.now();
            correctTime();
          },
        );
      }

      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        resetTime();
      });
      return Text(
        "$hour:$minute",
        style: style,
      );
    },
  );
}
