import 'package:flutter/material.dart';

/// Checks if a Screen width is lower than 450.
/// If lower return True (Is mobile phone).
/// If greater return false (Other devices).
/// You can use this value inside the build method for creating
/// responsive apps.
bool checkIfMobile(BuildContext context) {
  if (MediaQuery.of(context).size.width > 450) {
    return false;
  }
  return true;
}
