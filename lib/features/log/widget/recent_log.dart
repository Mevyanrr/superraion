import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:superraion/core/constants/app_color.dart';

import '../viewmodel/log_viewmodel.dart';

class RecentLogCard extends StatelessWidget {
  const RecentLogCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recent",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        SizedBox(height: 12.h),

        Consumer<RecentLogViewModel>(
          builder: (context, vm, child) {
            final log = vm.recentLog;
            if (log == null) return const SizedBox.shrink();

            return InkWell(
              onTap: () => vm.navigateToDetail(context),
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFF3F4F6)), // Border soft
                ),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: AppColors.pinkSoft, // Soft red background
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.restaurant_rounded,
                          color: AppColors.pinkDark, // Primary Pink/Red
                          size: 28.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),

                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Recent",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                vm.getTimeAgo(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF9CA3AF), // Neutral 400
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Icon(Icons.circle, size: 4.sp, color: const Color(0xFF9CA3AF)),
                              ),
                              Text(
                                log.mealName,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Arrow Icon
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: const Color(0xFFD1D5DB), // Neutral 300
                      size: 22.sp,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}