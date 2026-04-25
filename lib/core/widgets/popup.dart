import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants/app_color.dart';
import '../viewmodel/popup_viewmodel.dart';

class SavedPopupView extends StatelessWidget {
  const SavedPopupView({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SavedPopupView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavedPopupViewModel(),
      child: Consumer<SavedPopupViewModel>(
        builder: (context, vm, _) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mascot Image
                  Image.asset(
                    "assets/images/mascot_happy.png",
                    width: 120.w,
                    height: 120.w,
                  ),
                  SizedBox(height: 24.h),

                  // Text Content
                  Text(
                    "Saved!",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Log for 3 days to unlock your first insights",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => vm.navigateToHome(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinkDark,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Back To Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}