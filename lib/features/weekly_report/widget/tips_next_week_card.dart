import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../viewmodel/weekly_report.dart';

Widget buildTipsSection(WeeklyAnalysisViewModel vm) {
  return Consumer<WeeklyAnalysisViewModel>(
    builder: (context, vm, _) {
      if (vm.tips.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Tips for Next Week",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937))),
          SizedBox(height: 12.h),
          ...vm.tips.map((tip) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFFF3F4F6)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.tips_and_updates_outlined,
                      color: const Color(0xFFF87171), size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.title,
                          maxLines: 3,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1F2937))),
                      SizedBox(height: 4.h),
                      Text(tip.subtitle,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF6B7280))),
                      if (tip.highlight.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(tip.highlight,
                              style: TextStyle(
                                  color: const Color(0xFFF87171),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.sp)),
                        ),
                    ],
                  ),
                ),

              ],
            ),
          )),
        ],
      );
    },
  );
}