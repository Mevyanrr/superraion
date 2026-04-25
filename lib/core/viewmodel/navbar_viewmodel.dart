import 'package:flutter/cupertino.dart';

class NavbarViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index, BuildContext context) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();

      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/log');
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/profil');
          break;
      }
    }
  }
}