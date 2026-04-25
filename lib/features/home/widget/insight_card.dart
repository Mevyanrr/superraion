import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../viewmodel/home_viewmodel.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InsightViewModel(),
      child: Consumer<InsightViewModel>(
        builder: (context, vm, _) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEBF3FE), // Light Blue Background
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Colors.blue, size: 24.sp),
                    SizedBox(width: 10.w),
                    Text(
                      "We noticed something",
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Body Text
                Text(
                  "You often experience breakouts 1–2 days after eating fried foods. Try reducing them and see how your skin responds.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => vm.submitFeedback("Make Sense"),
                        icon: Icon(Icons.thumb_up_alt_outlined, size: 18.sp),
                        label: const Text("Make sense"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => vm.submitFeedback("Not Relevant"),
                        icon: Icon(Icons.thumb_down_alt_outlined, size: 18.sp),
                        label: const Text("Not relevant"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}