import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:superraion/user_model.dart';

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;
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


  Future<UserCredential> signUpWithEmail(UserModel usermodel) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: usermodel.email,
      password: usermodel.password,
    );
  }

  Future<UserCredential> loginWithEmail(UserModel usermodel) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: usermodel.email,
      password: usermodel.password,
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
}