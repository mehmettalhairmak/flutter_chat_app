import 'package:flutter/material.dart';
import 'package:flutter_chat_app/app/pages/chat.dart';
import 'package:flutter_chat_app/models/speech_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/viewmodel/view_model.dart';
import 'package:provider/provider.dart';

class MyChatPage extends StatefulWidget {
  const MyChatPage({Key? key}) : super(key: key);

  @override
  State<MyChatPage> createState() => _MyChatPageState();
}

class _MyChatPageState extends State<MyChatPage> {
  @override
  Widget build(BuildContext context) {
    ViewModel _viewModel = Provider.of<ViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konuşmalarım"),
      ),
      body: FutureBuilder<List<Speech>>(
        future: _viewModel.getAllConversations(_viewModel.user!.userID),
        builder: (context, speechList) {
          if (!speechList.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var allSpeech = speechList.data;

            return RefreshIndicator(
              onRefresh: _myChatListRefresh,
              child: ListView.builder(
                itemCount: allSpeech!.length,
                itemBuilder: (BuildContext context, int index) {
                  var speech = allSpeech[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: ((context) => ChatPage(
                              currentUser: _viewModel.user!,
                              chatUser: UserModel.idAndPicture(
                                userID: speech.toWho,
                                profileURL: speech.toWhoUserProfileURL,
                              ),
                            )),
                      ));
                    },
                    child: ListTile(
                      title: Text(speech.toWhoUserName!),
                      subtitle: Text(speech.lastMessage),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(speech.toWhoUserProfileURL!),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _myChatListRefresh() async {
    setState(() {});
    await Future.delayed(const Duration(seconds: 1));
  }
}
