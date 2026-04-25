import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:superraion/features/auth/view/login.dart';
import '../../../core/constants/app_color.dart';
import '../viewmodel/auth_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final birthdayCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  final Color primaryBlue = const Color(0xFF9CB1E6);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Stack(
                children: [
                  Image.asset(
                    'assets/images/vector2.png',
                    color: AppColors.primaryBlue,
                    colorBlendMode: BlendMode.srcIn,
                    scale: 0.8,
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Image.asset('assets/images/Ellipse_56.png', color: AppColors.primaryBlue,
                        colorBlendMode: BlendMode.srcIn,)),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: Image.asset('assets/images/Ellipse_53.png', color: AppColors.primaryBlue,
                      colorBlendMode: BlendMode.srcIn,),
                  ),
                ]
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Buat akun baru",
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F1F1F),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Buat akun dengan menggunakan\nemail dan nomor telepon",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                  ),

                  SizedBox(height: 25.h),

                  _buildLabel("Username"),
                  _buildTextField(
                    ctrl: nameCtrl,
                    hint: "Labubu labi-labi",
                    onChanged: vm.onRegNameChanged,
                    error: vm.regNameError,
                  ),

                  _buildLabel("Email"),
                  _buildTextField(
                    ctrl: emailCtrl,
                    hint: "labubu@gmail.com",
                    type: TextInputType.emailAddress,
                    onChanged: vm.onEmailChanged,
                    error: vm.emailError,
                  ),

                  _buildLabel("Kata Sandi"),
                  _buildPasswordField(
                    ctrl: passCtrl,
                    hint: "Minimal 8 karakter",
                    isObscured: vm.isRegPassObscured,
                    toggle: vm.toggleRegPass,
                    onChanged: vm.onRegPasswordChanged,
                    error: vm.regPasswordError,
                  ),

                  _buildLabel("Konfirmasi Kata Sandi"),
                  _buildPasswordField(
                    ctrl: confirmCtrl,
                    hint: "Ulangi kata sandimu",
                    isObscured: vm.isRegConfirmObscured,
                    toggle: vm.toggleRegConfirm,
                    onChanged: vm.onRegConfirmPasswordChanged,
                    error: vm.regConfirmPasswordError,
                  ),

                  SizedBox(height: 30.h),

                  SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        bool success = await vm.validateRegister(
                          name: nameCtrl.text,
                          email: emailCtrl.text,
                          password: passCtrl.text,
                          confirmPassword: confirmCtrl.text,
                        );

                        if(success){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LoginPage()),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue.withOpacity(0.8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  Text("atau daftar dengan", style: TextStyle(fontSize: 12.sp)),
                  SizedBox(height: 15.h),
                  _buildSocialIcons(),

                  SizedBox(height: 25.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Masuk",
                          style: TextStyle(
                            color: const Color(0xFF4C66CD),
                            fontWeight: FontWeight.bold,
                          ),
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
      ),
    );
  }


  Widget _buildLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 14.h, bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController ctrl,
    required String hint,
    TextInputType type = TextInputType.text,
    required Function(String) onChanged,
    String? error,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      onChanged: onChanged,
      style: TextStyle(fontSize: 14.sp),
      decoration: _inputDecoration(hint, error),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController ctrl,
    required String hint,
    required bool isObscured,
    required VoidCallback toggle,
    required Function(String) onChanged,
    String? error,
  }) {
    return TextField(
      controller: ctrl,
      obscureText: isObscured,
      onChanged: onChanged,
      style: TextStyle(fontSize: 14.sp),
      decoration: _inputDecoration(hint, error).copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            size: 20.w,
            color: Colors.black87,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, AuthViewModel vm) {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (picked != null) vm.setBirthDate(picked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: vm.regDateError != null ? Colors.red : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              vm.selectedBirthDate == null
                  ? "Pilih Tanggal Lahir"
                  : DateFormat('dd/MM/yyyy').format(vm.selectedBirthDate!),
              style: TextStyle(
                fontSize: 14.sp,
                color: vm.selectedBirthDate == null ? Colors.grey : Colors.black,
              ),
            ),
            Icon(Icons.calendar_month_outlined, color: Colors.grey, size: 20.w),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, String? error) {
    return InputDecoration(
      hintText: hint,
      errorText: error,
      hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
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
}