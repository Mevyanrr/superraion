import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../model/profil_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileModel? _userProfile;
  ProfileModel? get userProfile => _userProfile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> loadFromFirestore() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final userDoc = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .get();

      final data = userDoc.data();
      final username = data?['displayName'] ?? user.displayName ?? 'User';
      final email = data?['email'] ?? user.email ?? '';
      final photoURL = data?['photoURL'] ?? user.photoURL ?? '';

      _userProfile = ProfileModel(
        name: username,
        email: email,
        avatarUrl: photoURL,
      );
    } catch (e) {
      print('loadFromFirestore error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}