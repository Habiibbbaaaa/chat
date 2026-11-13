import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String? documentId;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.documentId,
  });

  // الدالة دي مهمة جداً: بتحول الكائن (Object) لـ Map
  // عشان Firebase مبيفهمش غير Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  // الدالة دي بنستخدمها لما نيجي "نقرأ" من Firebase
  // بتاخد الـ Map اللي جاية من النت وتحولها لـ MessageModel نفهمه في Flutter
  factory MessageModel.fromMap(String documentId, Map<String, dynamic> map) {
    return MessageModel(
      documentId: documentId,
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
