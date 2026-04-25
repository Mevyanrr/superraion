import 'package:flutter/material.dart';

import '../model/profil_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel? _userProfile;
  ProfileModel? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProfileData() async {
    _isLoading = true;
    notifyListeners();

    // Simulasi fetch dari Backend
    await Future.delayed(const Duration(seconds: 1));
    _userProfile = ProfileModel(
      name: "Kamilia Luthfitah",
      email: "mils@gmail.com",
      avatarUrl: "https://example.com/avatar.jpg", // Placeholder
    );

    _isLoading = false;
    notifyListeners();
  }
}