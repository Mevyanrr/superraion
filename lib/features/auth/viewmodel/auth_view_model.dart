import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  // --- STATE VISIBILITY ---
  bool isLoginPassObscured = true;
  bool isRegPassObscured = true;
  bool isRegConfirmObscured = true;

  // --- STATE DATA ---
  DateTime? selectedBirthDate;

  // --- ERROR STATES (Login) ---
  String? loginNameError;
  String? loginPasswordError;

  // --- ERROR STATES (Register) ---
  String? regNameError;
  String? emailError;
  String? regDateError;
  String? regPasswordError;
  String? regConfirmPasswordError;

  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  String loginName = "";
  String loginPassword = "";

  // --- TOGGLE VISIBILITY METHODS ---
  void toggleLoginPass() {
    isLoginPassObscured = !isLoginPassObscured;
    notifyListeners();
  }

  void toggleRegPass() {
    isRegPassObscured = !isRegPassObscured;
    notifyListeners();
  }

  void toggleRegConfirm() {
    isRegConfirmObscured = !isRegConfirmObscured;
    notifyListeners();
  }

  // --- DATA SETTER ---
  void setBirthDate(DateTime date) {
    selectedBirthDate = date;
    regDateError = null; // Healing error saat tanggal dipilih
    notifyListeners();
  }

  // --- AUTO-HEALING LOGIC (Login) ---
  void onLoginNameChanged(String val) {
    loginName = val; // Simpan ke variabel
    if (loginNameError != null) loginNameError = null;
    notifyListeners();
  }

  void onLoginPasswordChanged(String val) {
    loginPassword = val; // Simpan ke variabel
    if (loginPasswordError != null) loginPasswordError = null;
    notifyListeners();
  }

// --- TAMBAHKAN GETTER INI ---
  bool get isLoginValid {
    // Tombol aktif jika field tidak kosong (dan error null)
    return loginName.isNotEmpty &&
        loginPassword.isNotEmpty &&
        loginNameError == null &&
        loginPasswordError == null;
  }

  void onRegNameChanged(String val) {
    name = val; // Simpan ke variabel
    if (regNameError != null) regNameError = null;
    notifyListeners();
  }

  void onEmailChanged(String val) {
    email = val; // Simpan ke variabel
    if (emailError != null) emailError = null;
    notifyListeners();
  }

  void onRegPasswordChanged(String val) {
    password = val; // Simpan ke variabel
    if (regPasswordError != null) regPasswordError = null;
    notifyListeners();
  }

  void onRegConfirmPasswordChanged(String val) {
    confirmPassword = val; // Simpan ke variabel
    if (regConfirmPasswordError != null) regConfirmPasswordError = null;
    notifyListeners();
  }

  // --- VALIDATION LOGIC: LOGIN ---
  bool validateLogin(String username, String pass) {
    bool isValid = true;

    if (username.isEmpty) {
      loginNameError = "Username tidak boleh kosong";
      isValid = false;
    }

    if (pass.isEmpty) {
      loginPasswordError = "Kata sandi tidak boleh kosong";
      isValid = false;
    } else if (pass.length < 8) {
      loginPasswordError = "Sandi minimal 8 karakter";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  // --- VALIDATION LOGIC: REGISTER ---
  // Hapus parameter di dalam kurung
  bool validateRegister() {
    bool isValid = true;

    // Reset semua error terlebih dahulu
    regNameError = null;
    emailError = null;
    regPasswordError = null;
    regConfirmPasswordError = null;

    // Validasi menggunakan variabel class (this.name, this.email, dst)
    if (name.isEmpty) {
      regNameError = "Nama lengkap wajib diisi";
      isValid = false;
    }

    if (email.isEmpty || !email.contains('@')) {
      emailError = "Email tidak valid";
      isValid = false;
    }

    if (password.length < 8) {
      regPasswordError = "Minimal 8 karakter";
      isValid = false;
    }

    if (password != confirmPassword) {
      regConfirmPasswordError = "Kata sandi tidak cocok";
      isValid = false;
    }

    notifyListeners(); // Wajib agar UI terupdate

    if (isValid) {
      debugPrint("Register Berhasil!");
    }

    return isValid;
  }

  // --- RESET STATE ---
  void clearErrors() {
    loginNameError = null;
    loginPasswordError = null;
    emailError = null;
    regNameError = null;
    regDateError = null;
    regPasswordError = null;
    regConfirmPasswordError = null;
    notifyListeners();
  }

  // Di dalam class AuthViewModel
  bool get isRegisterValid {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        regNameError == null &&
        emailError == null &&
        regPasswordError == null &&
        regConfirmPasswordError == null;
  }
}