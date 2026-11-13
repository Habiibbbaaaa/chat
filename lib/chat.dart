import 'package:chatApp/theme/app_theme.dart';
import 'package:chatApp/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/chat_cubit.dart';
import '../cubits/chat_states.dart';

class Chat extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const Chat({super.key, required this.receiverId, required this.receiverName});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName),
      ), // اسم اللي بنكلمه فوق

      body: Column(
        children: [
          // 1. عرض الرسائل
          Expanded(
            child: BlocBuilder<ChatCubit, chatState>(
              builder: (context, state) {
                if (state is chatSuccess) {
                  return ListView.builder(
                    reverse: false,
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 10,
                    ),
                    itemCount: state.message.length,
                    itemBuilder: (context, index) {
                      var message = state.message[index];

                      return MessageBubble(
                        message: message.message,
                        isMe: message.senderId == state.myId,
                        timestamp: message.timestamp,
                        onDelete: () {
                          final chatCubit = context.read<ChatCubit>();

                          showDialog(
                            context: context,
                            builder: (_) {
                              return BlocProvider.value(
                                value: chatCubit,
                                child: AlertDialog(
                                  title: const Text('Delete message?'),
                                  content: const Text(
                                    'Are you sure you want to delete this message?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<ChatCubit>().deleteMessage(
                                              widget.receiverId,
                                              message.documentId!,
                                            );

                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),

          // 2. منطقة الكتابة
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Enter message...',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_messageController.text.isNotEmpty) {
                        // بننادي دالة الإرسال من الكيوبيت
                        context.read<ChatCubit>().sendMessage(
                              widget.receiverId,
                              _messageController.text,
                            );

                        _messageController.clear(); // نمسح النص بعد الإرسال
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
