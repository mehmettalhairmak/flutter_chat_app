import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/services/authentication/auth_base.dart';

class FakeAuthenticationService implements AuthBase {
  String userID = "123123123123";

  @override
  Future<UserModel?> currentUser() async {
    return await Future.value(
        UserModel(userID: userID, email: 'fakeuser@fake.com'));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    return await Future.delayed(
      const Duration(seconds: 5),
      () => UserModel(userID: userID, email: 'fakeuser@fake.com'),
    );
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => UserModel(
            userID: "google_user_id_123456", email: 'fakeuser@fake.com'));
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => UserModel(
            userID: "facebook_user_id_123456", email: 'fakeuser@fake.com'));
  }

  @override
  Future<UserModel?> signInWithEmailPassword(
      String email, String password) async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => UserModel(
            userID: 'signup_user_id_123456', email: 'fakeuser@fake.com'));
  }

  @override
  Future<UserModel?> signUpWithEmailPassword(
      String email, String password) async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => UserModel(
            userID: 'signin_user_id_123456', email: 'fakeuser@fake.com'));
  }
}
