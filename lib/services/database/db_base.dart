import 'package:flutter_chat_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updatePhotoURL(String userID, String profilePhotoURL);
  Future<List<UserModel>> getAllUser();
}
