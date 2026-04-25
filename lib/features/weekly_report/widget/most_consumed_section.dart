import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weekly_report.dart';

Widget buildMostConsumed(WeeklyAnalysisViewModel vm) {
  return Consumer<WeeklyAnalysisViewModel>(
    builder: (context, vm, _) {
      if (vm.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (vm.foodStats.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Top Triggers This Week",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Column(
              children: vm.foodStats.asMap().entries.map((entry) {
                final stat = entry.value;
                final isLast = entry.key == vm.foodStats.length - 1;

                return Container(
                  margin: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: stat.bgColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        stat.title,
                        style: TextStyle(
                          color: stat.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: stat.textColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          stat.count, // ini 'memperburuk' atau 'memperbaiki'
                          style: TextStyle(
                            color: stat.textColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      );
    },
  );
}