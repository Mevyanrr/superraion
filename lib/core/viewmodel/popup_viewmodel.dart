import 'package:flutter/cupertino.dart';

class SavedPopupViewModel extends ChangeNotifier {
  // Logika navigasi untuk kembali ke Home
  void navigateToHome(BuildContext context) {
    // Menggunakan pushNamedAndRemoveUntil agar stack navigasi bersih
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}