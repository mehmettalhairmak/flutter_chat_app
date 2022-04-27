import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/speech_model.dart';
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

  @override
  Future<bool> updatePhotoURL(String userID, String profilePhotoURL) async {
    await _firestore
        .collection("users")
        .doc(userID)
        .update({"profileURL": profilePhotoURL});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUser() async {
    QuerySnapshot querySnapshot = await _firestore.collection("users").get();

    List<UserModel> allUser = [];
    /*for (DocumentSnapshot document in querySnapshot.docs) {
      UserModel _user =
          UserModel.fromMap(document.data() as Map<String, dynamic>);
      allUser.add(_user);
    }*/

    //2. Yöntem

    allUser = querySnapshot.docs
        .map((e) => UserModel.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    return allUser;
  }

  @override
  Stream<List<Message>> getMessages(String currentUserID, String chatUserID) {
    var snapshot = _firestore
        .collection("chat")
        .doc(currentUserID + "--" + chatUserID)
        .collection("messages")
        .orderBy("date", descending: true)
        .snapshots();
    return snapshot.map((messageList) => messageList.docs
        .map((message) => Message.fromMap(message.data()))
        .toList());
  }

  @override
  Future<bool> saveMessage(Message saveMessage) async {
    var _messageID = _firestore.collection("chat").doc().id;
    var _myDocumentID = saveMessage.fromWho + "--" + saveMessage.toWho;
    var _receiverDocumentID = saveMessage.toWho + "--" + saveMessage.fromWho;
    var _saveMessageMap = saveMessage.toMap();

    await _firestore
        .collection("chat")
        .doc(_myDocumentID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessageMap);

    await _firestore.collection("chat").doc(_myDocumentID).set({
      "fromWho": saveMessage.fromWho,
      "toWho": saveMessage.toWho,
      "lastMessage": saveMessage.message,
      "isSeen": false,
      "createdDate": FieldValue.serverTimestamp()
    });

    _saveMessageMap.update("isFromMe", (value) => false);

    await _firestore
        .collection("chat")
        .doc(_receiverDocumentID)
        .collection("messages")
        .doc(_messageID)
        .set(_saveMessageMap);

    await _firestore.collection("chat").doc(_receiverDocumentID).set({
      "fromWho": saveMessage.toWho,
      "toWho": saveMessage.fromWho,
      "lastMessage": saveMessage.message,
      "isSeen": false,
      "createdDate": FieldValue.serverTimestamp()
    });

    return true;
  }

  @override
  Future<List<Speech>> getAllConverstaions(String userID) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection("chat")
        .where("fromWho", isEqualTo: userID)
        .orderBy("createdDate", descending: true)
        .get();

    List<Speech> allSpeech = [];

    for (DocumentSnapshot singleSpeech in querySnapshot.docs) {
      Speech _singleSpeech =
          Speech.fromMap(singleSpeech.data() as Map<String, dynamic>);
      allSpeech.add(_singleSpeech);
    }

    return allSpeech;
  }

  @override
  Future<DateTime> showTime(String userID) async {
    await _firestore.collection("server").doc(userID).set({
      "time": FieldValue.serverTimestamp(),
    });

    var readMap = await _firestore.collection("server").doc(userID).get();
    var readDate = readMap.data();
    Timestamp timeDate = readDate!["time"];
    return timeDate.toDate();
  }
}
