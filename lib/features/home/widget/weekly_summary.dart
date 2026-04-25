import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_color.dart';
import '../viewmodel/home_viewmodel.dart'; // Pastikan ViewModel sudah benar

class WeeklySummaryCard extends StatelessWidget {
  const WeeklySummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Weekly Summary",
          style: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1F2937)),
        ),
        SizedBox(height: 16.h),

        Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: const Color(0xFFF3F4F6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Consumer<WeeklySummaryViewModel>(
            builder: (context, vm, _) {
              if (vm.summaryData == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = vm.summaryData!;

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Symptoms trend",
                        style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF6B7280),
                            fontWeight: FontWeight.w500)),
                  ),
                  SizedBox(height: 25.h),

                  //Grafik
                  SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: TrendLinePainter(
                          data.symptomLevels, AppColors.pinkMedium),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  //days
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(data.days.length, (index) {
                      final day = data.days[index];
                      bool isToday = index == data.days.length - 1;

                      return Text(
                        day,
                        style: TextStyle(
                          //Hari ini: Hitam & Bold. Hari lain: Abu-abu.
                          color: isToday
                              ? const Color(0xFF111827)
                              : const Color(0xFF9CA3AF),
                          fontSize: 13.sp,
                          fontWeight:
                          isToday ? FontWeight.bold : FontWeight.w500,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 24.h),

                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                    decoration: BoxDecoration(
                      color: AppColors.pinkMedium,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Top Food",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12.sp)),
                              SizedBox(height: 4.h),
                              Text(data.topFood,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp)),
                            ],
                          ),
                        ),

                        Container(
                          height: 50.h,
                          width: 1,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          flex: 9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Insight",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12.sp)),
                              SizedBox(height: 4.h),
                              Text(
                                data.insight,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
//TOMBOL
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/weekly');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                      side: BorderSide(color: AppColors.pinkMedium),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r)),
                      elevation: 0,
                    ),
                    child: Text("View full report",
                        style: TextStyle(
                            color: AppColors.pinkMedium,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp)),
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
  final Color lineColor;

  TrendLinePainter(this.points, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    double dx = size.width / (points.length - 1);

    double getY(double value) => size.height * (1 - value);

    double startY = getY(points[0]);
    path.moveTo(0, startY);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, startY);

    for (int i = 1; i < points.length; i++) {
      double x = dx * i;
      double y = getY(points[i]);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    fillPaint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lineColor.withOpacity(0.2),
        lineColor.withOpacity(0.001),
      ],
      stops: const [0.1, 0.9],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    canvas.drawPath(path, linePaint);

    if (points.length > 1) {
      final lastX = size.width;
      final lastY = getY(points.last);

      final outerDotPaint = Paint()
        ..color = AppColors.pinkMedium
        ..style = PaintingStyle.fill;

      final innerDotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(lastX, lastY), 10.r, Paint()
        ..color = Colors.black.withOpacity(0.1)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));

      canvas.drawCircle(Offset(lastX, lastY), 10.r, outerDotPaint);
      canvas.drawCircle(Offset(lastX, lastY), 7.r, innerDotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant TrendLinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.lineColor != lineColor;
  }
}