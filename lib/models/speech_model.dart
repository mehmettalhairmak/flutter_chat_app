import 'package:cloud_firestore/cloud_firestore.dart';

class Speech {
  final String fromWho;
  final String toWho;
  final bool isSeen;
  final Timestamp? createdDate;
  final String lastMessage;
  final Timestamp? seenDate;
  String? toWhoUserName;
  String? toWhoUserProfileURL;
  DateTime? lastReadTime;
  String? localTime;

  Speech({
    required this.fromWho,
    required this.toWho,
    required this.isSeen,
    required this.createdDate,
    required this.lastMessage,
    required this.seenDate,
    this.toWhoUserName,
    this.toWhoUserProfileURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toWho': toWho,
      'isSeen': isSeen,
      'createdDate': createdDate ?? FieldValue.serverTimestamp(),
      'lastMessage': lastMessage,
      'seenDate': seenDate ?? FieldValue.serverTimestamp()
    };
  }

  Speech.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        toWho = map['toWho'],
        isSeen = map['isSeen'],
        createdDate = map['createdDate'],
        lastMessage = map['lastMessage'],
        seenDate = map['seenDate'];

  @override
  String toString() {
    return 'Speech(fromWho: $fromWho, toWho: $toWho, isSeen: $isSeen, createdDate: $createdDate, lastMessage: $lastMessage, seenDate: $seenDate)';
  }
}
