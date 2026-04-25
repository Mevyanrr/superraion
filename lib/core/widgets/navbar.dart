import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../../../core/viewmodel/navbar_viewmodel.dart';
import '../constants/app_color.dart';


class MainNavbarView extends StatelessWidget {
  const MainNavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NavbarViewModel>();

    return SizedBox(
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 80.h),
            painter: NavbarPainter(),
          ),
          Center(
            heightFactor: 0.6,
            child: _buildFab(context, vm),
          ),
          SizedBox(
            height: 80.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, Icons.home_rounded, "Home", vm),
                const SizedBox(width: 40),
                _buildNavItem(context, 2, Icons.person_rounded, "Profile", vm),
              ],
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildFab(BuildContext context, NavbarViewModel vm) {
    bool isSelected = vm.currentIndex == 1;

    return GestureDetector(
    onTap: () {
    vm.setIndex(1, context);
    },
    child: Container(
    width: 56.w,
    height: 56.w,
    decoration: BoxDecoration(
    shape: BoxShape.circle,

    color: AppColors.pinkMedium,
    boxShadow: [
    BoxShadow(
    color: Colors.black26,
    blurRadius: isSelected ? 15 : 10,
    offset: const Offset(0, 4)
    )
    ],
    ),
    child: Image.asset(
    "assets/images/pencilmagic.png",
    width: 5.w,
    height: 5.w,
    )
    ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, NavbarViewModel vm) {
    bool isSelected = vm.currentIndex == index;

    return GestureDetector(
      onTap: () => vm.setIndex(index, context), // ← fix di sini
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pinkMedium : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : const Color(0xFF4B5563), size: 24.sp),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(label,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
            ],
          ],
        ),
      ),
    );
  }
}

class NavbarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Radius "lubang" dan kedalaman
    final double midX = size.width / 2;
    final double holeWidth = 90.0; // Lebar lubang (sesuaikan dengan lebar FAB kamu)
    final double holeDepth = 55.0; // Kedalaman lengkungan

    Path path = Path();

    path.moveTo(0, 20);
    path.quadraticBezierTo(0, 0, 20, 0);

    path.lineTo(midX - (holeWidth / 2), 0);

    // 3. Lengkungan (Cubic Bezier)
    // Titik kontrol pertama: tarik ke bawah
    // Titik tengah: dasar lengkungan
    // Titik kontrol kedua: tarik ke atas
    path.cubicTo(
      midX - (holeWidth / 2) + 15, 0,
      midX - (holeWidth / 2) + 15, holeDepth,
      midX, holeDepth,
    );

    path.cubicTo(
      midX + (holeWidth / 2) - 15, holeDepth,
      midX + (holeWidth / 2) - 15, 0,
      midX + (holeWidth / 2), 0,
    );

    // 4. Lanjut ke kanan sampai selesai
    path.lineTo(size.width - 20, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Gambar Shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 10, true);

    // Gambar Bentuk Navbar
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}