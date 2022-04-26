import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/app/pages/sign_in/email_password_signup_signin.dart';
import 'package:flutter_chat_app/viewmodel/view_model.dart';
import 'package:flutter_chat_app/app/widgets/social_login_button.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat App'),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(height: 8),
            SocialLoginButton(
              buttonText: "Gmail ile Giriş Yap",
              textColor: Colors.black87,
              buttonColor: Colors.white,
              buttonIcon: Image.asset("images/google-logo.png"),
              onPressed: () => signInWithGoogle(context),
            ),
            SocialLoginButton(
              buttonText: "Facebook ile Giriş Yap",
              buttonColor: const Color(0xFF334D92),
              buttonIcon: Image.asset("images/facebook-logo.png"),
              textColor: Colors.white,
              onPressed: () => signInWithFacebook(context),
            ),
            SocialLoginButton(
              buttonText: "Email ve Şifre ile Giriş Yap",
              buttonIcon: const Icon(
                Icons.email,
                size: 32,
              ),
              onPressed: () => signInWithEmailPassword(context),
            ),
             SocialLoginButton(
              buttonText: "Misafir Girişi",
              buttonColor: Colors.teal,
              buttonIcon: const Icon(
                Icons.supervised_user_circle,
                size: 32,
              ),
              onPressed: () => anonymousLogin(context),
            ) 
          ],
        ),
      ),
    );
  }

   void anonymousLogin(BuildContext context) async {
    final _userViewModel = Provider.of<ViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInAnonymously();
    debugPrint('Oturum Açan User ID : ${_user?.userID.toString()}');
  } 

  void signInWithGoogle(BuildContext context) async {
    final _userViewModel = Provider.of<ViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInWithGoogle();
    debugPrint('Oturum Açan User ID : ${_user?.userID.toString()}');
  }

  void signInWithFacebook(BuildContext context) async {
    final _userViewModel = Provider.of<ViewModel>(context, listen: false);
    UserModel? _user = await _userViewModel.signInWithFacebook();
    debugPrint('Oturum Açan User ID : ${_user?.userID.toString()}');
  }

  void signInWithEmailPassword(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EmailPasswordLoginPage()));
  }
}
