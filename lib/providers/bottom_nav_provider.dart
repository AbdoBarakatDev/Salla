import 'package:flutter/cupertino.dart';

class BottomNavProvider extends ChangeNotifier {
  int indexOfBottomNavBar = 0;

  onBottomNavBarTapped(int value) {
    indexOfBottomNavBar = value;
    notifyListeners();
  }
}
