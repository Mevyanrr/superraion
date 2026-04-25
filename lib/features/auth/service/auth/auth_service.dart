import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:superraion/features/auth/model/user_model.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  static bool _isGoogleInitialized = false;

  static Future<void> _initGoogleSignIn() async {
    if (!_isGoogleInitialized) {
      await _googleSignIn.initialize(
        serverClientId:
        "497053976903-62igeq8ktk2iqoa06mp68vh94gihgg1v.apps.googleusercontent.com",
      );
      _isGoogleInitialized = true;
    }
  }


  Future<UserCredential> signUpWithEmail(String name, String email, String password) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> loginWithEmail(String email, String password) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }


  Future<UserCredential?> signInWithGoogle() async {
    try {

      await _initGoogleSignIn();


      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();


      final String? idToken = googleUser.authentication.idToken;

      GoogleSignInClientAuthorization? authorization =
      await googleUser.authorizationClient.authorizationForScopes(
        ['email', 'profile'],
      );

      authorization ??=
      await googleUser.authorizationClient.authorizationForScopes(
        ['email', 'profile'],
      );

      final String? accessToken = authorization?.accessToken;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );


      return await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      final msg = e.toString();

      if (msg.contains('canceled') ||
          msg.contains('cancelled') ||
          msg.contains('sign_in_canceled') ||
          msg.contains('ApiException: 12501')) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      firebaseAuth.signOut(),
      _googleSignIn.signOut().catchError((_) {}),
    ]);
  }

  User? get currentUser => firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();
  bool get isLoggedIn => firebaseAuth.currentUser != null;


  Exception _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return Exception('Email sudah terdaftar dengan metode lain.');
      case 'invalid-credential':
        return Exception('Kredensial tidak valid. Coba lagi.');
      case 'user-disabled':
        return Exception('Akun ini telah dinonaktifkan.');
      case 'network-request-failed':
        return Exception('Tidak ada koneksi internet.');
      default:
        return Exception(e.message ?? 'Terjadi kesalahan. Coba lagi.');
    }
  }

  Future<void> resetPassword({required String email}) async {
    return await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> saveUser(String name, DateTime birthdate) async {
    final user = firebaseAuth.currentUser;


    final userRef = firestore.collection('user_superraion').doc(user?.uid);
    try{
      return userRef.set({
        'uid': user?.uid,
        'email': user?.email ?? "",
        'displayName': name,
        'birth_date': birthdate,
        'photoURL': user?.photoURL ?? "",
        'lastSignIn': FieldValue.serverTimestamp(),

      }, SetOptions(merge: true)
      );

    }catch(e){
      log("Error $e");
    }
  }

  Future<UserModel?> getUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      final doc = await firestore
          .collection('user_superraion')
          .doc(user.uid)
          .get();

      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      log("Error getUser: $e");
      return null;
    }
  }

  Future<int> getUserStreak() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return 0;

    try {
      final snapshot = await firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('food_log')
          .get();


      final loggedDates = snapshot.docs
          .map((doc) => doc.data()['log_date'] as String?)
          .whereType<String>()
          .toSet();


      int streak = 0;
      DateTime checkDate = DateTime.now();

      while (true) {
        final dateStr = DateFormat('yyyy-MM-dd').format(checkDate);
        if (loggedDates.contains(dateStr)) {
          streak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        } else {
          break;
        }
      }

      return streak;
    } catch (e) {
      log("Error getUserStreak: $e");
      return 0;
    }
  }
}