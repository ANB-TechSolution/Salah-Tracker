import 'package:flutter/material.dart';

class HelperFunction {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
