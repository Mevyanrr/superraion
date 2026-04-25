import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedSplashPage extends StatefulWidget {
  const AnimatedSplashPage({super.key});

  @override
  State<AnimatedSplashPage> createState() => _AnimatedSplashPageState();
}

class _AnimatedSplashPageState extends State<AnimatedSplashPage> with TickerProviderStateMixin {

  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 3; i++) {
      _controllers.add(
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 600),
        ),
      );

      _animations.add(
        Tween<double>(begin: 0.3, end: 1.0).animate(
          CurvedAnimation(parent: _controllers[i], curve: Curves.easeInOut),
        ),
      );

      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/mascot.png', width: 200.w),
            SizedBox(height: 24.h),
            Image.asset("assets/images/ohmygut.png"),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => FadeTransition(
                opacity: _animations[index],
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: 12.w,
                  height: 12.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFCA5A5),
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ),
          ],
        ),
      ),
    );
  }
}