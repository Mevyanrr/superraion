import 'package:flutter/material.dart';
import '../model/onboarding_model.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  // Tambahkan variabel ini agar tidak merah lagi
  double _autoScrollValue = 0.0;
  double get autoScrollValue => _autoScrollValue;

  double _scrollOffset = 0.0;
  double get scrollOffset => _scrollOffset;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  late AnimationController _controller;

  final List<OnboardingData> items = [
    OnboardingData(title: "Onboarding1", description: "Deskripsi 1", imagePath: 'assets/images/onboarding0.png'),
    OnboardingData(title: "Onboarding2", description: "Deskripsi 2", imagePath: 'assets/images/onboarding1.png'),
    OnboardingData(title: "Onboarding3", description: "Deskripsi 3", imagePath: 'assets/images/onboarding2.png'),
    OnboardingData(title: "Onboarding4", description: "Deskripsi 4", imagePath: 'assets/images/onboarding3.png'),
  ];

  void initAnimation(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 15),
    )..addListener(() {
      _autoScrollValue = _controller.value;
      notifyListeners();
    });

    _controller.repeat(reverse: true);

    pageController.addListener(() {
      _scrollOffset = pageController.page ?? 0;
      notifyListeners();
    });
  }

  void onPageChanged(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void nextPage() {
    pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    pageController.dispose();
    super.dispose();
  }
}