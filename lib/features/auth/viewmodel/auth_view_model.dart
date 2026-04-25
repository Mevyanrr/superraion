import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/auth/auth_service.dart';

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
    if (loginNameError != null) {
      loginNameError = null;
      notifyListeners();
    }
  }

  void onLoginPasswordChanged(String val) {
    if (loginPasswordError != null) {
      loginPasswordError = null;
      notifyListeners();
    }
  }

  // --- AUTO-HEALING LOGIC (Register) ---
  void onRegNameChanged(String val) {
    if (regNameError != null) {
      regNameError = null;
      notifyListeners();
    }
  }

  void onEmailChanged(String val) {
    if (emailError != null) {
      emailError = null;
      notifyListeners();
    }
  }

  void onRegPasswordChanged(String val) {
    if (regPasswordError != null) {
      regPasswordError = null;
      notifyListeners();
    }
  }

  void onRegConfirmPasswordChanged(String val) {
    if (regConfirmPasswordError != null) {
      regConfirmPasswordError = null;
      notifyListeners();
    }
  }

  // --- VALIDATION LOGIC: LOGIN ---
  Future <bool> validateLogin(String email, String pass) async {
    bool isValid = true;

    if (email.isEmpty) {
      loginNameError = "Email tidak boleh kosong";
      isValid = false;
    }

    if (pass.isEmpty) {
      loginPasswordError = "Kata sandi tidak boleh kosong";
      isValid = false;
    } else if (pass.length < 8) {
      loginPasswordError = "Sandi minimal 8 karakter";
      isValid = false;
    }



    if (!isValid) return false;
    try{
      await AuthService().loginWithEmail(email, pass);
      debugPrint("login Berhasil!");
      return true;
    }catch(e){
      debugPrint("login Gagal");
      return false;
    }

  }

  // --- VALIDATION LOGIC: REGISTER ---
  Future <bool> validateRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    bool isValid = true;

    if (name.isEmpty) {
      regNameError = "Nama lengkap wajib diisi";
      isValid = false;
    }

    if (email.isEmpty || !email.contains('@')) {
      emailError = "Email tidak valid";
      isValid = false;
    }

    // if (selectedBirthDate == null) {
    //   regDateError = "Pilih tanggal lahir";
    //   isValid = false;
    // }

    if (password.length < 8) {
      regPasswordError = "Minimal 8 karakter";
      isValid = false;
    }

    if (password != confirmPassword) {
      regConfirmPasswordError = "Kata sandi tidak cocok";
      isValid = false;
    }

    notifyListeners();

    if (!isValid) return false;
      try{
        await AuthService().signUpWithEmail(name,email, password);
        await FirebaseAuth.instance.currentUser?.reload();
        await AuthService().saveUser(name, selectedBirthDate?? DateTime.now());
        debugPrint("Register Berhasil!");
        return true;
      }catch(e){
        debugPrint("Register Gagal");
        return false;
      }

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
}