import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildExpertInsight() {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(color: const Color(0xFFF3F4F6)),
    ),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(radius: 20.r, backgroundImage: const AssetImage("assets/images/dokter.png")),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Dr. Anjay", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text("Health Specialist", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            )
          ],
        ),
        SizedBox(height: 12.h),
        RichText(
          text: TextSpan(
            style: TextStyle(color: const Color(0xFF374151), fontSize: 13.sp, height: 1.5),
            children: const [
              TextSpan(text: "Your gut can influence your skin and mood more than you think. This week, you consumed "),
              TextSpan(text: "more dairy, gluten, and fried foods,", style: TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold)),
              TextSpan(text: " which may be linked to your "),
              TextSpan(text: "recent breakouts and mood changes.", style: TextStyle(color: Color(0xFFF87171), fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    ),
  );
}