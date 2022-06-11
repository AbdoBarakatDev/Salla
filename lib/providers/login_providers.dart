import 'package:flutter/material.dart';

class LoginProviders extends ChangeNotifier {
  bool isVisible = true;

  changeVisibility(bool value) {
    isVisible = value;
    notifyListeners();
  }
}
