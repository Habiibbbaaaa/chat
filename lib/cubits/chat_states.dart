import 'package:chatApp/message_model.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

abstract class chatState {}

class chatInitial extends chatState {}

class chatLoading extends chatState {}

class chatSuccess extends chatState {
  final List<MessageModel> message;
  final String myId;

  chatSuccess(this.message, this.myId);
}

class chatFail extends chatState {
  final String message;
  chatFail(this.message);
}
