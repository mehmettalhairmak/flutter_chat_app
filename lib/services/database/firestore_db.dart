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
}
