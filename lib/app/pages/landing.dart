import 'package:flutter/material.dart';
import 'package:flutter_chat_app/app/pages/home.dart';
import 'package:flutter_chat_app/app/pages/sign_in/sign_in.dart';
import 'package:flutter_chat_app/viewmodel/view_model.dart';
import 'package:provider/provider.dart';

class LangingPage extends StatelessWidget {
  const LangingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _viewModel = Provider.of<ViewModel>(context);

    if (_viewModel.viewState == ViewState.IDLE) {
      if (_viewModel.user == null) {
        return const SignInPage();
      } else {
        return HomePage(user: _viewModel.user);
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
