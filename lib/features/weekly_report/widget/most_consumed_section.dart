import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../viewmodel/weekly_report.dart';

Widget buildMostConsumed(WeeklyAnalysisViewModel vm) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Most Consumed This Week",
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
        child: Row(
          children: vm.foodStats.asMap().entries.map((entry) {
            final stat = entry.value;
            final isLast = entry.key == vm.foodStats.length - 1;

            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: isLast ? 0 : 8.w),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: stat.bgColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stat.title,
                      style: TextStyle(
                        color: stat.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      stat.count,
                      style: TextStyle(
                        color: stat.textColor.withOpacity(0.7),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}