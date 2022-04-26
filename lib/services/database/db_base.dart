import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/speech_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updatePhotoURL(String userID, String profilePhotoURL);
  Future<List<UserModel>> getAllUser();
  Future<List<Speech>> getAllConverstaions(String userID);
  Stream<List<Message>> getMessages(String currentUserID, String chatUserID);
  Future<bool> saveMessage(Message saveMessage);
}
