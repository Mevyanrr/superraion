import 'package:flutter/cupertino.dart';

class SavedPopupViewModel extends ChangeNotifier {
  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}