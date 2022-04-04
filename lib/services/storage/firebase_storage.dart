import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_chat_app/services/storage/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  late Reference _reference;

  @override
  Future<String> uploadFile(String userID, String fileType, File file) async {
    _reference = _firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child("profile_photo.png");

    var _uploadTask = _reference.putFile(file);

    var url = await (await _uploadTask).ref.getDownloadURL();

    return url;
  }
}
