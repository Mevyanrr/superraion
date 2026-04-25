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
    OnboardingData(title: "Hear Your Skin", description: "Your breakouts might be linked to your gut health", imagePath: 'assets/images/onboarding0.png'),
    OnboardingData(title: "It Starts Within", description: "Hair fall can be a sign your gut needs attention", imagePath: 'assets/images/onboarding1.png'),
    OnboardingData(title: "Not Just Food", description: "Your gut plays a key role in weight balance", imagePath: 'assets/images/onboarding2.png'),
    OnboardingData(title: "Gut Shapes Mood", description: "Anxious or low? Your gut might be the reason", imagePath: 'assets/images/onboarding3.png'),
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