import 'package:flutter/material.dart';
import 'package:flutter_chat_app/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: <Widget>[
          TextButton(
            onPressed: () => signOut(context),
            child: const Text(
              "Çıkış Yap",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: const Center(
        child: Text('Profil Sayfası'),
      ),
    );
  }

  Future<bool> signOut(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool value = await _userViewModel.signOut();
    return value;
  }
}
