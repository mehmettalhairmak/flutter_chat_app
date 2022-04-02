// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/locator.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/repository/user_repository.dart';
import 'package:flutter_chat_app/services/authentication/auth_base.dart';

enum ViewState { IDLE, BUSY }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _viewState = ViewState.IDLE;

  final UserRepository _userRepository = locator<UserRepository>();
  // ignore: unused_field
  UserModel? _user;
  String? emailErrorMessage;
  String? passwordErrorMessage;

  UserModel? get user => _user;

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      viewState = ViewState.BUSY;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("ViewModel currentUser Hata : ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      viewState = ViewState.BUSY;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      debugPrint("ViewModel signInAnonymously Hata : ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      viewState = ViewState.BUSY;
      bool value = await _userRepository.signOut();
      _user = null;
      return value;
    } catch (e) {
      debugPrint("ViewModel signOut Hata : ${e.toString()}");
      return false;
    } finally {
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      viewState = ViewState.BUSY;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (e) {
      debugPrint("ViewModel signInWithGoogle Hata : ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    try {
      viewState = ViewState.BUSY;
      _user = await _userRepository.signInWithFacebook();
      return _user;
    } catch (e) {
      debugPrint("ViewModel signInWithFacebook Hata : ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel?> signInWithEmailPassword(
      String email, String password) async {
    try {
      if (checkEmailPassword(email, password)) {
        viewState = ViewState.BUSY;
        _user = await _userRepository.signInWithEmailPassword(email, password);
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("ViewModel signInEmailPassword Hata : ${e.toString()}");
      return null;
    } finally {
      viewState = ViewState.IDLE;
    }
  }

  @override
  Future<UserModel?> signUpWithEmailPassword(
      String email, String password) async {
    if (checkEmailPassword(email, password)) {
      try {
        viewState = ViewState.BUSY;
        _user = await _userRepository.signUpWithEmailPassword(email, password);
        return _user;
      } finally {
        viewState = ViewState.IDLE;
      }
    } else {
      return null;
    }
  }

  bool checkEmailPassword(String email, String password) {
    var sonuc = true;

    if (password.length < 6) {
      passwordErrorMessage = "En az 6 karakter olmalı";
      sonuc = false;
    } else {
      passwordErrorMessage = null;
    }
    if (!email.contains('@')) {
      emailErrorMessage = "Geçersiz email adresi";
      sonuc = false;
    } else {
      emailErrorMessage = null;
    }

    return sonuc;
  }
}
