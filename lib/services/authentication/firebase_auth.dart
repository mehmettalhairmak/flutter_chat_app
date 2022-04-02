import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/services/authentication/auth_base.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return UserModel(userID: user.uid, email: user.email!);
    }
  }

  @override
  Future<UserModel?> currentUser() async {
    User? user = _firebaseAuth.currentUser;
    try {
      return _userFromFirebase(user);
    } catch (e) {
      debugPrint('HATA CURRENT USER : ${e.toString()}');
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint("HATA SIGN OUT ${e.toString()}");
      return false;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      debugPrint("HATA ANONYMOUSLY SIGNIN ${e.toString()}");
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential value = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken,
          idToken: _googleAuth.idToken,
        ));
        User _user = value.user!;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();
    FacebookLoginResult _facebookResult = await _facebookLogin.logIn(
        permissions: [
          FacebookPermission.email,
          FacebookPermission.publicProfile
        ]);
    switch (_facebookResult.status) {
      case FacebookLoginStatus.success:
        if (_facebookResult.accessToken != null) {
          UserCredential _firebaseCredential = await _firebaseAuth
              .signInWithCredential(FacebookAuthProvider.credential(
                  _facebookResult.accessToken!.token));
          User _user = _firebaseCredential.user!;
          return _userFromFirebase(_user);
        } else {}
        break;
      case FacebookLoginStatus.cancel:
        debugPrint('Kullanıcı facebook girişi iptal etti');
        break;
      case FacebookLoginStatus.error:
        debugPrint('Hata Çıktı : ${_facebookResult.error}');
        break;
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithEmailPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<UserModel?> signUpWithEmailPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user);
  }
}
