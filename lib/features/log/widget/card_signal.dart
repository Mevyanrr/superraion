import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignalCard extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeBgColor;
  final Color activeTextColor;

  const SignalCard({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    required this.activeBgColor,
    required this.activeTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        decoration: BoxDecoration(
          color: isSelected ? activeBgColor : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 40.w, height: 40.w),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeTextColor : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}