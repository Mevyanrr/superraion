import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../weekly_report/viewmodel/weekly_report.dart';
import '../viewmodel/home_viewmodel.dart';

class InsightCard extends StatelessWidget {
  const InsightCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<InsightViewModel, BodyInsightViewModel>(
      builder: (context, insightVm, bodyVm, _) {

        final aiInsight = bodyVm.insights.isNotEmpty
            ? bodyVm.insights.first
            : null;

        final title = aiInsight != null
            ? aiInsight.text.split('\n').first // ambil headline
            : "We noticed something";

        final body = aiInsight != null
            ? aiInsight.text.split('\n').skip(1).join('\n') // ambil explanation
            : "You often experience breakouts 1–2 days after eating fried foods. Try reducing them and see how your skin responds.";

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEBF3FE),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: Colors.blue, size: 24.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Text(
                body,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF4B5563),
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => insightVm.submitFeedback("Make Sense"),
                      icon: Icon(Icons.thumb_up_alt_outlined, size: 18.sp),
                      label: const Text("Make sense"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => insightVm.submitFeedback("Not Relevant"),
                      icon: Icon(Icons.thumb_down_alt_outlined, size: 18.sp),
                      label: const Text("Not relevant"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}