import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superraion/features/onboarding/view/parallax.dart';
import '../../../core/constants/app_color.dart';
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
              final bool isLastItem = index == vm.items.length - 1;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 60.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
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
                            ],
                          ),
                        ),

                        if (!isLastItem) SizedBox(width: 20.w),

                        if (!isLastItem) _buildNextArrow(vm),
                      ],
                    ),

                    if (isLastItem) ...[
                      SizedBox(height: 40.h),
                      _buildStartButton(context),
                      SizedBox(height: 20.h),
                    ],

                    if (!isLastItem) SizedBox(height: 60.h),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextArrow(OnboardingViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => vm.nextPage(),
          child: Image.asset(
            'assets/images/nextarrow.png',
            width: 50.w,
            height: 50.h,
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pinkDark,
          foregroundColor: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 18.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          elevation: 0,
        ),
        child: Text(
          "Mulai Sekarang",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp, color: AppColors.textWhite),
        ),
      ),
    );
  }
}