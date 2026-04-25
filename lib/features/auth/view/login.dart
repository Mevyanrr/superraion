import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../widget/custom_textfield.dart';
import '../viewmodel/auth_view_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Consumer<AuthViewModel>(
        builder: (context, vm, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/vector.png',
                      color: AppColors.pinkMedium,
                      colorBlendMode: BlendMode.srcIn,
                      scale: 0.8,
                    ),
                    Positioned(
                        top: 0,
                        left: 270,
                        child: Image.asset('assets/images/Ellipse_51.png',
                          color: AppColors.pinkMedium,
                          colorBlendMode: BlendMode.srcIn,)),
                    Positioned(
                      bottom: 80,
                      left: 10,
                      child: Image.asset(
                        'assets/images/Ellipse_53.png', color: AppColors.pinkMedium,
                        colorBlendMode: BlendMode.srcIn,),
                    ),
                    Positioned(
                        top: 75,
                        left: 50,
                        child: Image.asset(
                          'assets/images/nama_apps.png',
                          scale: 0.8,
                        )
                    )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Text(
                          "Selamat datang!",
                          style: TextStyle(
                              fontSize: 28.sp, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 8.h),
                      Text(
                          "Silakan masuk menggunakan nomor\ntelepon yang sudah terdaftar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14.sp, color: AppColors.textBlack)
                      ),

                      SizedBox(height: 32.h),

                      CustomTextField(
                        label: "Username",
                        hint: "Labubu",
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        activeColor: AppColors.pinkMedium,
                        errorText: vm.loginNameError,
                        onChanged: vm.onLoginNameChanged,
                      ),

                      SizedBox(height: 20.h),

                      CustomTextField(
                        label: "Kata Sandi",
                        hint: "Minimal 8 karakter",
                        controller: passController,
                        isPassword: true,
                        isObscured: vm.isLoginPassObscured,
                        onToggleVisibility: vm.toggleLoginPass,
                        activeColor: AppColors.pinkMedium,
                        errorText: vm.loginPasswordError,
                        onChanged: vm.onLoginPasswordChanged,
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {},
                            child: Text("Lupa sandi?", style: TextStyle(
                                color: AppColors.textBlack, fontSize: 13.sp))
                        ),
                      ),

                      SizedBox(height: 10.h),

                      // BUTTON MASUK
                      SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(

                          onPressed: vm.isLoginValid
                              ? () => vm.validateLogin(vm.loginName, vm.loginPassword)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pinkDark,
                            disabledBackgroundColor: AppColors.pinkMedium,
                            disabledForegroundColor: Colors.white.withOpacity(0.6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.r)),
                          ),
                          child: Text(
                              "Masuk",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.textWhite,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ),
                      ),

                      SizedBox(height: 30.h),
                      Text("atau masuk dengan",
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                      SizedBox(height: 16.h),

                      _buildSocialIcons(),

                      SizedBox(height: 30.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum punya akun? ",
                              style: TextStyle(fontSize: 14.sp)),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/register'),
                            child: Text(
                                "Daftar",
                                style: TextStyle(color: AppColors.pinkMedium,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp)
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ... Widget _buildSocialIcons dan _buildSocialIconBox tetap sama ...

Widget _buildSocialIcons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _socialIconBox('assets/images/apple.png'),
      SizedBox(width: 15.w),
      _socialIconBox('assets/images/google.png'),
      SizedBox(width: 15.w),
      _socialIconBox('assets/images/facebook.png'),
    ],
  );
}

Widget _socialIconBox(String path) {
  return Container(
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[200]!),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Image.asset(path, width: 22.w, height: 22.w,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.circle, size: 22.w, color: Colors.grey[300])),
  );
}

