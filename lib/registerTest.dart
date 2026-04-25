import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:superraion/auth_service.dart';
import 'package:superraion/auth_text_field.dart';
import 'package:superraion/primary_button.dart';
import 'package:superraion/user_model.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService().signUpWithEmail(
        UserModel(
          nama: "apa",
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );

      _showSuccess('Akun berhasil dibuat!');
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Terjadi kesalahan');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.06),

                    // Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color:
                          colors.surfaceContainerHighest.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colors.outline.withOpacity(0.15),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 17,
                          color: colors.onSurface,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            colors.tertiary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        color: colors.onPrimary,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Title
                    Text(
                      'Buat Akun\nBaru ✨',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Isi data di bawah untuk membuat akun',
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.onSurface.withOpacity(0.55),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Nama
                    AuthTextField(
                      label: 'Nama Lengkap',
                      hint: 'Masukkan nama kamu',
                      icon: Icons.person_outline_rounded,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        if (val.trim().length < 2) {
                          return 'Nama minimal 2 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Email
                    AuthTextField(
                      label: 'Email',
                      hint: 'contoh@email.com',
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(val)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Password
                    AuthTextField(
                      label: 'Password',
                      hint: 'Minimal 8 karakter',
                      icon: Icons.lock_outline_rounded,
                      controller: _passwordController,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (val.length < 8) {
                          return 'Password minimal 8 karakter';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    // Konfirmasi Password
                    AuthTextField(
                      label: 'Konfirmasi Password',
                      hint: 'Ulangi password kamu',
                      icon: Icons.lock_reset_outlined,
                      controller: _confirmPasswordController,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (val != _passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // Register Button
                    PrimaryButton(
                      text: 'Daftar',
                      onPressed: _handleRegister,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 28),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await AuthService().signInWithGoogle();
                        if (result != null) {
                          // Sukses → navigasi ke Home

                        }
                      },
                      child: Text('Masuk dengan Google'),
                    ),

                    const SizedBox(height: 32),

                    // Sudah punya akun
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: TextStyle(
                            color: colors.onSurface.withOpacity(0.55),
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            'Masuk di sini',
                            style: TextStyle(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
