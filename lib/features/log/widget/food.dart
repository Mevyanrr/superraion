import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../viewmodel/log_viewmodel.dart';

class FoodIntake extends StatelessWidget {
  const FoodIntake({super.key});

  @override
  Widget build(BuildContext context) {
    return const FoodIntakeCard();
  }
}

class FoodIntakeCard extends StatelessWidget {
  const FoodIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FoodIntakeViewModel>();  // ← FoodIntakeViewModel

    return Container(
      width: 350.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5.w),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10.r, offset: Offset(0, 4.h))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: 20.h),
          Text('Food Categories',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF111827))),
          SizedBox(height: 12.h),
          _buildCategoryWrap(vm),
          SizedBox(height: 20.h),
          _buildDetailsLabel(),
          SizedBox(height: 8.h),
          _buildTextField(vm),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(color: AppColors.pinkSoft, shape: BoxShape.circle),
          child: Image.asset("assets/images/foodintake.png"),
        ),
        SizedBox(width: 10.w),
        Text('Food Intake',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF111827))),
      ],
    );
  }

  Widget _buildCategoryWrap(FoodIntakeViewModel vm) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: List.generate(vm.categories.length, (index) {
        final cat = vm.categories[index];
        final isPressing = vm.pressingCategories.contains(cat.name);

        Color bgColor = const Color(0xFFF3F4F6);
        Color textColor = const Color(0xFF6B7280);
        Color borderColor = const Color(0xFFD1D5DB);

        if (isPressing) {
          bgColor = const Color(0xFFE91E63);
          textColor = Colors.white;
          borderColor = const Color(0xFFE91E63);
        } else if (cat.isSelected) {
          bgColor = const Color(0xFFFCE4EC);
          textColor = const Color(0xFFE91E63);
          borderColor = const Color(0xFFE91E63);
        }

        return GestureDetector(
          onTapDown: (_) => vm.setPressing(cat.name, true),
          onTapUp: (_) {
            vm.setPressing(cat.name, false);
            vm.toggleCategory(index);
          },
          onTapCancel: () => vm.setPressing(cat.name, false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: borderColor, width: 1.w),
            ),
            child: Text(cat.name,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: textColor)),
          ),
        );
      }),
    );
  }

  Widget _buildDetailsLabel() {
    return RichText(
      text: TextSpan(
        text: 'Add Food Details ',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: const Color(0xFF111827)),
        children: [
          TextSpan(
            text: '(optional)',
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400, color: const Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(FoodIntakeViewModel vm) {
    return TextField(
      controller: vm.detailsController,
      maxLines: 2,
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        hintText: 'What are you eating?',
        hintStyle: TextStyle(fontSize: 14.sp, color: const Color(0xFFD1D5DB)),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: const Color(0xFFE5E7EB), width: 1.w)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: const Color(0xFFE5E7EB), width: 1.w)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: const Color(0xFFE91E63), width: 1.5.w)),
      ),
    );
  }
}