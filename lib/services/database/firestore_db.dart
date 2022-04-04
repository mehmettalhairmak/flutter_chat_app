import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/services/database/db_base.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.userID).set(user.toMap());

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(user.userID).get();

    if (snapshot.data() == null) {
      await _firestore.collection('users').doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readingUser =
        await _firestore.collection('users').doc(userID).get();

    Map<String, dynamic> _readingUserDetailsMap =
        _readingUser.data() as Map<String, dynamic>;

    UserModel _readingUserObject = UserModel.fromMap(_readingUserDetailsMap);

    return _readingUserObject;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();

    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firestore
          .collection("users")
          .doc(userID)
          .update({"userName": newUserName});
      return true;
    }
  }

  Future<bool> updatePhotoURL(String userID, String profilePhotoURL) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({"profileURL": profilePhotoURL});
    return true;
  }
}
