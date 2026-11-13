import 'dart:async';
import 'package:chatApp/message_model.dart';
import 'package:bloc/bloc.dart';
import 'package:chatApp/cubits/chat_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatCubit extends Cubit<chatState> {
  ChatCubit() : super(chatInitial());

  StreamSubscription? _messagesSubscription;

  /// generate chat id
  String generateChatId(String uid1, String uid2) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    return ids.join("_");
  }

  /// receive messages
  void getMessages(String receiverId) {
    emit(chatLoading());

    final myId = FirebaseAuth.instance.currentUser!.uid;

    final chatId = generateChatId(myId, receiverId);

    _messagesSubscription = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen(
      // channel بتجيب الرسائل الجديده اول ما تبعت او تستلم
      (snapshot) {
        final myId = FirebaseAuth.instance.currentUser!.uid;
        final messages = snapshot.docs.map((doc) {
          return MessageModel.fromMap(
            doc.id,
            doc.data(),
          );
        }).toList();

        emit(chatSuccess(messages, myId));
      },
      onError: (error) {
        emit(chatFail(error.toString()));
      },
    );
  }

  /// send message
  void sendMessage(String receiverId, String message) {
    final myId = FirebaseAuth.instance.currentUser!.uid;

    final chatId = generateChatId(myId, receiverId);

    MessageModel newMessage = MessageModel(
      senderId: myId,
      receiverId: receiverId,
      message: message,
      timestamp: Timestamp.now(),
    );

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // delete message
  void deleteMessage(String receiverId, String messageId) {
    final myId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = generateChatId(myId, receiverId);

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

/////////////
  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
//بتتقفل تلقائياً في اللحظة اللي بتمسحي فيها صفحة  الشات من الـ Navigation Stack.
//اول ما نطلع من الصفحه او ندوس back
// to prevent Memory Leak



