import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../viewmodel/weekly_report.dart';

class MedicalNoteCard extends StatelessWidget {
  const MedicalNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MedicalNoteViewModel>(
      builder: (context, vm, child) {
        final data = vm.note;
        if (data == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  Icon(
                    Icons.warning_amber_rounded,
                    color: const Color(0xFFFBBF24),
                    size: 32.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    data.title,
                    style: TextStyle(
                      fontSize: 19.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                data.description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF374151),
                  height: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}