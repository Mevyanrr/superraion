import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_color.dart';
import '../viewmodel/home_viewmodel.dart';

class WeeklySummaryCard extends StatelessWidget {
  const WeeklySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Summary",
          style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: const Color(0xFFF3F4F6)),
          ),
          child: Consumer<WeeklySummaryViewModel>(
            builder: (context, vm, _) {
              if (vm.summaryData == null) return const Center(child: CircularProgressIndicator());
              final data = vm.summaryData!;

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Symptoms trend", style: TextStyle(fontSize: 15.sp, color: Colors.grey[600])),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: CustomPaint(painter: TrendLinePainter(data.symptomLevels)),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: data.days.map((day) => Text(day, style: TextStyle(color: Colors.grey[400], fontSize: 13.sp))).toList(),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
                    decoration: BoxDecoration(
                      color: AppColors.pinkMedium,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Top Food", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                              Text(data.topFood, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        Container(height: 30.h, width: 1, color: Colors.white30),
                        SizedBox(width: 16.w),
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Insight", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                              Text(data.insight, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                      side: const BorderSide(color: Color(0xFFF87171)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                    child: Text("View full report", style: TextStyle(color: const Color(0xFFF87171), fontWeight: FontWeight.bold)),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class TrendLinePainter extends CustomPainter {
  final List<double> points;
  TrendLinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF87171)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final path = Path();
    double dx = size.width / (points.length - 1);

    path.moveTo(0, size.height * (1 - points[0]));
    for (int i = 1; i < points.length; i++) {
      path.lineTo(dx * i, size.height * (1 - points[i]));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}