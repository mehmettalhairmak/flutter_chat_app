import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/home.dart';
import 'package:flutter_chat_app/pages/sign_in/sign_in.dart';
import 'package:flutter_chat_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class LangingPage extends StatelessWidget {
  const LangingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userViewModel = Provider.of<UserViewModel>(context);

    if (_userViewModel.viewState == ViewState.IDLE) {
      if (_userViewModel.user == null) {
        return const SignInPage();
      } else {
        return HomePage(user: _userViewModel.user);
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
