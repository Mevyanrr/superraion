import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../viewmodel/weekly_report.dart';

Widget buildTipsSection(WeeklyAnalysisViewModel vm) {
  return Container(
    padding: EdgeInsets.all(20.w),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24.r)),
    child: ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.tips.length,
      separatorBuilder: (_, __) => SizedBox(height: 20.h),
      itemBuilder: (context, index) {
        final tip = vm.tips[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${index + 1}.", style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(tip.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp)),
                      SizedBox(width: 4.w),
                      Text(tip.highlight, style: TextStyle(color: const Color(0xFF4ADE80), fontWeight: FontWeight.bold, fontSize: 15.sp)),
                    ],
                  ),
                  Text(tip.subtitle, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                ],
              ),
            )
          ],
        );
      },
    ),
  );
}