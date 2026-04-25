import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
          return Theme(
            data: Theme.of(context).copyWith(
              dialogBackgroundColor: Colors.transparent,
            ),
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: 350.w,
                    margin: EdgeInsets.only(top: 60.h),
                    padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 32.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15.h),
                        Text(
                          "Saved!",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Log for 3 days to unlock your first insights",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: const Color(0xFF6B7280),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => vm.navigateToHome(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF87171),
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

                  // --- 2. MASCOT (POSISI MENGAMBANG SETENGAH BADAN) ---
                  Positioned(
                    top: 0, // Letakkan tepat di batas atas margin container
                    child: Image.asset(
                      "assets/images/mascot.png",
                      width: 130.w, // Ukuran mascot disesuaikan
                      fit: BoxFit.contain,
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