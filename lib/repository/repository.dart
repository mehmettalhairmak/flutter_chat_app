// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:flutter_chat_app/models/message_model.dart';
import 'package:flutter_chat_app/models/speech_model.dart';
import 'package:flutter_chat_app/models/user_model.dart';
import 'package:flutter_chat_app/services/authentication/auth_base.dart';
import 'package:flutter_chat_app/services/authentication/fake_auth.dart';
import 'package:flutter_chat_app/services/authentication/firebase_auth.dart';
import 'package:flutter_chat_app/services/database/firestore_db.dart';
import 'package:flutter_chat_app/services/storage/firebase_storage.dart';
import '../locator.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class Repository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();

  final FakeAuthenticationService _fakeAuthenticationService =
      locator<FakeAuthenticationService>();

  final FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();

  final FirebaseStorageService _firestoreStorageService =
      locator<FirebaseStorageService>();

  List<UserModel> allUserList = [];

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
      UserModel? _user = await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      UserModel? _user = await _firebaseAuthService.signInWithGoogle();
      bool _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithFacebook();
    } else {
      UserModel? _user = await _firebaseAuthService.signInWithFacebook();
      bool _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> signInWithEmailPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithEmailPassword(
          email, password);
    } else {
      UserModel? _user =
          await _firebaseAuthService.signInWithEmailPassword(email, password);
      return _firestoreDBService.readUser(_user!.userID);
    }
  }

  @override
  Future<UserModel?> signUpWithEmailPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signUpWithEmailPassword(
          email, password);
    } else {
      UserModel? _user =
          await _firebaseAuthService.signUpWithEmailPassword(email, password);
      bool _sonuc = await _firestoreDBService.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, newUserName);
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File? profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return "file_download_link";
    } else {
      var profilePhotoURL = await _firestoreStorageService.uploadFile(
          userID, fileType, profilePhoto!);

      await _firestoreDBService.updatePhotoURL(userID, profilePhotoURL);

      return profilePhotoURL;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      allUserList = await _firestoreDBService.getAllUser();

      return allUserList;
    }
  }

  Stream<List<Message>> getMessages(String currentUserID, String chatUserID) {
    if (appMode == AppMode.DEBUG) {
      return const Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, chatUserID);
    }
  }

  Future<bool> saveMessage(Message saveMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveMessage(saveMessage);
    }
  }

  Future<List<Speech>> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _time = await _firestoreDBService.showTime(userID);

      var speechList = await _firestoreDBService.getAllConverstaions(userID);

      for (var thisChat in speechList) {
        var userListThisUser = listFindUser(thisChat.toWho);

        if (userListThisUser != null) {
          print("VERİLER CACHE'DEN OKUNDU");
          thisChat.toWhoUserName = userListThisUser.userName;
          thisChat.toWhoUserProfileURL = userListThisUser.profileURL;
        } else {
          print("VERİLER DATABASE'DEN OKUDNU");
          print("Aranan user daha öncesinde veritabanına getirilmemiştir. ");
          var _databaseReadUser =
              await _firestoreDBService.readUser(thisChat.toWho);
          thisChat.toWhoUserName = _databaseReadUser.userName;
          thisChat.toWhoUserProfileURL = _databaseReadUser.profileURL;
        }
        timestampCalculate(thisChat, _time);
      }
      return speechList;
    }
  }

  UserModel? listFindUser(String userID) {
    for (var i = 0; i < allUserList.length; i++) {
      if (allUserList[i].userID == userID) {
        return allUserList[i];
      }
    }
    return null;
  }

  timestampCalculate(Speech thisChat, DateTime _time) {
    thisChat.lastReadTime = _time;
    var _duration = _time.difference(thisChat.createdDate!.toDate());
    thisChat.localTime =
        timeago.format(_time.subtract(_duration), locale: "tr");
  }
}
