import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_color.dart';
import '../viewmodel/auth_view_model.dart';
import '../widget/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset('assets/images/vector.png',
                      color: AppColors.pinkMedium, colorBlendMode: BlendMode.srcIn, scale: 0.8),
                  Positioned(top: 0, left: 270,
                      child: Image.asset('assets/images/Ellipse_51.png',
                          color: AppColors.pinkMedium, colorBlendMode: BlendMode.srcIn)),
                  Positioned(bottom: 80, left: 10,
                      child: Image.asset('assets/images/Ellipse_53.png',
                          color: AppColors.pinkMedium, colorBlendMode: BlendMode.srcIn)),
                  Positioned(top: 75, left: 50,
                      child: Image.asset('assets/images/nama_apps.png', scale: 0.8,
                          errorBuilder: (_, __, ___) => Text("OhMyGut",
                              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white)))),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Text("Selamat datang!",
                        style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    Text("Silakan masuk menggunakan email\nyang sudah terdaftar",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.black54)),

                    SizedBox(height: 32.h),

                    CustomTextField(
                      label: "Email",
                      hint: "Labubu@gmail.com",
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
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
                          child: Text("Lupa sandi?",
                              style: TextStyle(color: Colors.black54, fontSize: 13.sp))),
                    ),

                    SizedBox(height: 10.h),

                    // Tombol Email Login
                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await vm.validateLogin(
                            nameController.text,
                            passController.text,
                          );
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/log');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pinkMedium,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.r)),
                        ),
                        child: Text("Masuk",
                            style: TextStyle(fontSize: 16.sp, color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),

                    SizedBox(height: 30.h),
                    Text("atau masuk dengan", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    SizedBox(height: 16.h),

                    // Tombol Google
                    _buildGoogleButton(context, vm),

                    if (vm.googleError != null) ...[
                      SizedBox(height: 8.h),
                      Text(vm.googleError!,
                          style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                    ],

                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya akun? ", style: TextStyle(fontSize: 14.sp)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: Text("Daftar",
                              style: TextStyle(color: AppColors.pinkMedium,
                                  fontWeight: FontWeight.bold, fontSize: 14.sp)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton(BuildContext context, AuthViewModel vm) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton.icon(
        onPressed: () async {
          final success = await vm.signInWithGoogle();
          if (success && context.mounted) {
            Navigator.pushReplacementNamed(context, '/log');
          }
        },
        icon: Image.asset('assets/images/google.png', width: 22.w, height: 22.w,
            errorBuilder: (_, __, ___) => Icon(Icons.g_mobiledata, size: 22.w)),
        label: Text("Masuk dengan Google",
            style: TextStyle(fontSize: 14.sp, color: Colors.black87,
                fontWeight: FontWeight.w500)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[300]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        ),
      ),
    );
  }
}