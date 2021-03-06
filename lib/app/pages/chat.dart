// ignore_for_file: implementation_imports

import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/viewmodel/view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel chatUser;

  const ChatPage({Key? key, required this.currentUser, required this.chatUser})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel _currentUser = widget.currentUser;
    UserModel _chatUser = widget.chatUser;
    final _viewModel = Provider.of<ViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _viewModel.getMessages(
                    _currentUser.userID, _chatUser.userID),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<Message>? allMessages = snapshot.data;
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _createTextBalloon(allMessages![index]);
                      },
                    );
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      cursorColor: Colors.blueGrey,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Mesaj??n??z?? Yaz??n",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        if (_messageController.text.trim().isNotEmpty) {
                          Message _saveMessage = Message(
                            fromWho: _currentUser.userID,
                            toWho: _chatUser.userID,
                            isFromMe: true,
                            message: _messageController.text,
                          );
                          var result =
                              await _viewModel.saveMessage(_saveMessage);
                          if (result) {
                            _messageController.clear();
                            _scrollController.animateTo(
                              0.0,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeOut,
                            );
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createTextBalloon(Message message) {
    Color _getMessageColor = Colors.blue;
    Color _sendMessageColor = Theme.of(context).primaryColor;
    var _timeValue = "";
    var isMyMessage = message.isFromMe;

    try {
      _timeValue = _showHourMinute(message.date ?? Timestamp(1, 1));
    } catch (e) {
      debugPrint("Hata Var : $e");
    }

    if (isMyMessage) {
      return Padding(
        padding: const EdgeInsets.all(8), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _sendMessageColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      message.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_timeValue)
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.chatUser.profileURL!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _getMessageColor,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      message.message,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(_timeValue)
              ],
            )
          ],
        ),
      );
    }
  }

  String _showHourMinute(Timestamp? date) {
    var _formatter = DateFormat.Hm();
    var _formatDate = _formatter.format(date!.toDate());
    return _formatDate;
  }
}
