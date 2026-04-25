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
              // --- HEADER SECTION (Pixel Perfect Figma) ---
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
                      child: Image.asset('assets/images/Ellipse_51.png', color: AppColors.pinkMedium,
                        colorBlendMode: BlendMode.srcIn,)),
                  Positioned(
                    bottom: 80,
                    left: 10,
                    child: Image.asset('assets/images/Ellipse_53.png', color: AppColors.pinkMedium,
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
                        style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 8.h),
                    Text(
                        "Silakan masuk menggunakan nomor\ntelepon yang sudah terdaftar",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14.sp, color: Colors.black54)
                    ),

                    SizedBox(height: 32.h),


                    CustomTextField(
                      label: "Email",
                      hint: "Labubu@gmail.com",
                      controller: nameController,
                      keyboardType: TextInputType.text, // Ubah ke text kalau login pakai username
                      activeColor: AppColors.pinkMedium,
                      errorText: vm.loginNameError, // PAKAI loginNameError, bukan regNameError
                      onChanged: vm.onLoginNameChanged, // PAKAI onLoginNameChanged
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
                      errorText: vm.loginPasswordError, // Tambahkan ini agar error password muncul
                      onChanged: vm.onLoginPasswordChanged, // Tambahkan ini agar error sembuh saat ngetik
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: Text("Lupa sandi?", style: TextStyle(color: Colors.black54, fontSize: 13.sp))
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Main Button
                    SizedBox(
                      width: double.infinity,
                      height: 55.h,
                      child: ElevatedButton(
                        onPressed: () => vm.validateLogin(nameController.text, passController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pinkMedium, // Saya buat full warna agar terlihat aktif
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                        ),
                        child: Text(
                            "Masuk",
                            style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),
                    Text("atau masuk dengan", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                    SizedBox(height: 16.h),

                    _buildSocialIcons(),

                    SizedBox(height: 30.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Belum punya akun? ", style: TextStyle(fontSize: 14.sp)),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/register'),
                          child: Text(
                              "Daftar",
                              style: TextStyle(color: AppColors.pinkMedium, fontWeight: FontWeight.bold, fontSize: 14.sp)
                          ),
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


}

Widget _buildSocialIcons() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _socialIconBox('assets/icons/apple.png'),
      SizedBox(width: 15.w),
      _socialIconBox('assets/icons/google.png'),
      SizedBox(width: 15.w),
      _socialIconBox('assets/icons/facebook.png'),
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

