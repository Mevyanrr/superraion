import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_color.dart';
import '../viewmodel/log_viewmodel.dart';

class WaterIntakeCard extends StatelessWidget {
  const WaterIntakeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LogViewModel>();

    return Container(
      width: 350.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildIcon(),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Water Intake",
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1F1F1F)),
                      ),
                      Text(
                        "Daily Goal: 2.5L",
                        style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                vm.status,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600, color: const Color(0xFF4C84F3)),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Total Amount Display
          Center(
            child: Text(
              vm.formattedLiters,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: const Color(0xFF4C84F3)),
            ),
          ),
          SizedBox(height: 16.h),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: vm.progress, //nilai progress
              minHeight: 12.h,

              //warna track
              backgroundColor: Color(0XFFEDF0FA),
              //BIRU PROGRESSNYA
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4C84F3)),
            ),
          ),
          SizedBox(height: 12.h),

          // Labels under progress bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel("Low (<1L)"),
              _buildLabel("Med (2.5L)"),
              _buildLabel("High (>2L)"),
            ],
          ),
          SizedBox(height: 24.h),

          // Buttons
          Row(
            children: [
              Expanded(child: _IntakeButton(label: "250 ML", onTap: vm.removeWater, isAdd: false)),
              SizedBox(width: 16.w),
              Expanded(child: _IntakeButton(label: "250 ML", onTap: vm.addWater, isAdd: true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(color: const Color(0xFFEAF2FF), shape: BoxShape.circle),
      child: Icon(Icons.water_drop_outlined, color: const Color(0xFF4C84F3), size: 24.w),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]));
  }
}

class _IntakeButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isAdd;

  const _IntakeButton({required this.label, required this.onTap, required this.isAdd});

  @override
  State<_IntakeButton> createState() => _IntakeButtonState();
}

class _IntakeButtonState extends State<_IntakeButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 55.h,
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFF4C84F3) : const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(25.r),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.isAdd ? Icons.add : Icons.remove,
                color: _isPressed ? Colors.white : Colors.grey[600], size: 20.w),
            SizedBox(width: 8.w),
            Text(
              widget.label,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: _isPressed ? Colors.white : Colors.grey[700]
              ),
            ),
          ],
        ),
      ),
    );
  }
}