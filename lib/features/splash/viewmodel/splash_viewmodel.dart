import 'package:flutter/cupertino.dart';

import '../../../main.dart';

class SplashViewModel extends ChangeNotifier {
  void startSplashSequence() async {
    //page 1
    await Future.delayed(const Duration(seconds: 2));

    //page2
    navigatorKey.currentState?.pushReplacementNamed('/animated-splash');


    await Future.delayed(const Duration(seconds: 3));

    //ke onborading
    navigatorKey.currentState?.pushReplacementNamed('/onboarding');
  }
}