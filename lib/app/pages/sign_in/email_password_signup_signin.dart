// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/app/pages/sign_in/error_exception.dart';
import 'package:flutter_chat_app/viewmodel/user_view_model.dart';
import 'package:flutter_chat_app/app/widgets/cross_platform_notification.dart';
import 'package:flutter_chat_app/app/widgets/social_login_button.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
enum FormType { REGISTER, LOGIN }

class EmailPasswordLoginPage extends StatefulWidget {
  const EmailPasswordLoginPage({Key? key}) : super(key: key);

  @override
  State<EmailPasswordLoginPage> createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  // ignore: unused_field
  String _email = "", _password = "";
  late String _buttonText, _linkText;
  var _formType = FormType.LOGIN;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    _buttonText = _formType == FormType.LOGIN ? "Giriş Yap" : "Kayıt Ol";
    _linkText = _formType == FormType.LOGIN
        ? "Hesabınız Yok Mu? Kayıt Olun"
        : "Hesabınız Var Mı? O Zaman Giriş Yapın";

    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.user != null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Giriş / Kayıt"),
      ),
      body: _userViewModel.viewState == ViewState.IDLE
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: "admin@admin.com",
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email),
                          hintText: "Email",
                          labelText: "Email",
                          border: const OutlineInputBorder(),
                          errorText: _userViewModel.emailErrorMessage != null
                              ? _userViewModel.emailErrorMessage
                              : null,
                        ),
                        onSaved: (String? value) => _email = value!,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: "admin123",
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          hintText: "Password",
                          labelText: "Password",
                          border: const OutlineInputBorder(),
                          errorText: _userViewModel.passwordErrorMessage != null
                              ? _userViewModel.passwordErrorMessage
                              : null,
                        ),
                        onSaved: (String? value) => _password = value!,
                      ),
                      const SizedBox(height: 16),
                      SocialLoginButton(
                        buttonText: _buttonText,
                        buttonColor: Theme.of(context).primaryColor,
                        radius: 10,
                        onPressed: () => formSubmit(),
                      ),
                      TextButton(
                        child: Text(
                          _linkText,
                          style: const TextStyle(color: Colors.black),
                        ),
                        onPressed: () => _changeFormType(),
                      )
                    ],
                  ),
                ),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  void formSubmit() async {
    _formKey.currentState?.save();
    debugPrint("Email : $_email\nŞifre : $_password");
    final _userModel = Provider.of<UserViewModel>(context, listen: false);

    if (_formType == FormType.LOGIN) {
      try {
        UserModel? _currentUser =
            await _userModel.signInWithEmailPassword(_email, _password);
        if (_currentUser != null) {
          debugPrint('Oturum Açan User ID : ${_currentUser.userID.toString()}');
        }
      } on FirebaseAuthException catch (e) {
        debugPrint("Widget Oturum Açma Hata Yakalandı ${e.code.toString()}");

        CrossPlatformAlertDialog(
          title: "Oturum Açma Hata",
          content: Errors.showError(e.code),
          mainButtonTitle: "Tamam",
        ).show(context);
      }
    } else {
      try {
        UserModel? _currentUser =
            await _userModel.signUpWithEmailPassword(_email, _password);
        if (_currentUser != null) {
          debugPrint('Oturum Açan User ID : ${_currentUser.userID.toString()}');
        }
      } on FirebaseAuthException catch (e) {
        debugPrint(
            "Widget Hesap Oluşturma Hata Yakalandı ${Errors.showError(e.code)}");
        CrossPlatformAlertDialog(
          title: "Kullanıcı Oluşturma Hata",
          content: Errors.showError(e.code),
          mainButtonTitle: "Tamam",
        ).show(context);
      }
    }
  }

  void _changeFormType() => setState(() => _formType =
      _formType == FormType.LOGIN ? FormType.REGISTER : FormType.LOGIN);
}
