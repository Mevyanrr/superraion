import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants/app_color.dart';
import '../viewmodel/navbar_viewmodel.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavbarViewModel>(
      builder: (context, vm, child) {
        return Container(
          margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 30.h),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10.sp,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home Button
              _buildNavItem(
                context,
                index: 0,
                label: "Home",
                icon: Icons.home,
                isSelected: vm.selectedIndex == 0,
              ),

              // Edit Button (Center)
              _buildCenterButton(context, isSelected: vm.selectedIndex == 1),

              // Profile Button
              _buildNavItem(
                context,
                index: 2,
                label: "Profile",
                icon: Icons.person_outline,
                isSelected: vm.selectedIndex == 2,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, {required int index, required String label, required IconData icon, required bool isSelected}) {
    final vm = context.read<NavbarViewModel>();


    final activeColor = AppColors.pinkDark;
    final inactiveColor = Colors.grey;

    return GestureDetector(
      onTap: () => vm.updateIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? activeColor : inactiveColor, size: 24.sp),
            if (isSelected) SizedBox(width: 8.w),
            if (isSelected) Text(label, style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context, {required bool isSelected}) {
    final vm = context.read<NavbarViewModel>();
    return GestureDetector(
      onTap: () => vm.updateIndex(1),
      child: Container(
        width: 50.w,
        height: 50.w,
        decoration: BoxDecoration(
          color: AppColors.pinkDark,
          shape: BoxShape.circle,
          boxShadow: isSelected ? [BoxShadow(color: AppColors.pinkDark.withOpacity(0.3), blurRadius: 8)] : [],
        ),
        child: Icon(Icons.edit, color: Colors.white, size: 24.sp),
      ),
    );
  }
}