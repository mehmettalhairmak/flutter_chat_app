import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String fromWho;
  final String toWho;
  final bool isFromMe;
  final String message;
  final Timestamp? date;

  Message({
    required this.fromWho,
    required this.toWho,
    required this.isFromMe,
    required this.message,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toWho': toWho,
      'isFromMe': isFromMe,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp()
    };
  }

  Message.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        toWho = map['toWho'],
        isFromMe = map['isFromMe'],
        message = map['message'],
        date = map['date'];

  @override
  String toString() {
    return "Mesaj {fromWho : $fromWho, toWho : $toWho, isFromMe : $isFromMe, message : $message, date : $date}";
  }
}
