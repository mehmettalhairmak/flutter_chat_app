import 'package:flutter/material.dart';
import 'package:flutter_chat_app/viewmodel/user_view_model.dart';
import 'package:flutter_chat_app/widgets/cross_platform_notification.dart';
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
            onPressed: () => signOutAccept(context),
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

  Future signOutAccept(BuildContext context) async {
    final result = await const CrossPlatformAlertDialog(
      title: "Emin Misiniz?",
      content: "Çıkmak istediğinizden emin misiniz?",
      mainButtonTitle: "Evet",
      cancelButtonTitle: "Vazgeç",
    ).show(context);

    if (result == true) {
      signOut(context);
    }
  }
}
