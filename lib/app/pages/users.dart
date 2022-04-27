import 'package:flutter/material.dart';
import 'package:flutter_chat_app/app/pages/chat.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/viewmodel/view_model.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    ViewModel _viewModel = Provider.of<ViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kullanıcılar'),
      ),
      body: RefreshIndicator(
        onRefresh: _userListRefresh,
        child: FutureBuilder<List<UserModel>>(
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
                      return GestureDetector(
                        child: ListTile(
                          title: Text(currentUser.userName!),
                          subtitle: Text(currentUser.email!),
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(currentUser.profileURL!),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context, rootNavigator: true)
                              .push(MaterialPageRoute(
                            builder: ((context) => ChatPage(
                                  currentUser: _viewModel.user!,
                                  chatUser: currentUser,
                                )),
                          ));
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return RefreshIndicator(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 150,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.supervised_user_circle,
                              color: Theme.of(context).primaryColor,
                              size: 120,
                            ),
                            const Text(
                              "Henüz Kayıtlı Kullanıcı Yok",
                              style: TextStyle(fontSize: 24),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onRefresh: _userListRefresh,
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> _userListRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }
}
