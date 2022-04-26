import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userID;
  String? email;
  String? userName;
  String? profileURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? seviye;

  UserModel({required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email!.substring(0, email!.indexOf('@')) + createRandomNumber(),
      'profileURL': profileURL ?? "",
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profileURL = map['profileURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];

  UserModel.idAndPicture({required this.userID, required this.profileURL});

  String createRandomNumber() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
