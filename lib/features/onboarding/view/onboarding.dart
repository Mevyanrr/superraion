import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superraion/features/onboarding/view/parallax.dart';
import '../viewmodel/onboarding_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingViewModel>().initAnimation(this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();
    final isLastPage = vm.currentIndex == vm.items.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          const ParallaxImageLayer(),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          PageView.builder(
            controller: vm.pageController,
            onPageChanged: vm.onPageChanged,
            itemCount: vm.items.length,
            itemBuilder: (context, index) {
              final data = vm.items[index];
              return Padding(
                padding:  EdgeInsets.symmetric(horizontal: 30.w, vertical: 60.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      data.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16.sp,
                        height: 1.5.h,
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              );
            },
          ),

          Positioned(
            bottom: 50.h,
            left: 30.w,
            right: 30.w,
            child: isLastPage
                ? _buildStartButton(context) //tombol halaman 4
                : _buildNextArrow(vm),      //tombol halaman 1, 2, 3
          ),
        ],
      ),
    );
  }

  Widget _buildNextArrow(OnboardingViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.white,
          onPressed: () => vm.nextPage(),
          child: const Icon(Icons.arrow_forward_rounded, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          //NAVIGASI ABIS BUTTON MULAI BRO
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text(
          "Mulai Sekarang",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}