import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/viewmodel/view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ViewModel _viewModel = Provider.of<ViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcılar'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.title, color: Colors.white),
              onPressed: () {})
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _viewModel.getAllUser(),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.hasData) {
            var allUser = snapshot.data;
            if (allUser!.length - 1 > 0) {
              return ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (BuildContext context, int index) {
                  var currentUser = snapshot.data![index];
                  if (currentUser.userID != _viewModel.user!.userID) {
                    return ListTile(
                      title: Text(currentUser.userName!),
                      subtitle: Text(currentUser.email),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(currentUser.profileURL!),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              );
            } else {
              return const Center(child: Text("Kayıtlı bir kullanıcı yok"));
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
