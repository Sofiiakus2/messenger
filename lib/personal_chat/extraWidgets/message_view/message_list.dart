import 'package:flutter/material.dart';

import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import 'message_view.dart';

class MessageList extends StatelessWidget {
  final ScrollController scrollController;
  final List<MessageModel> messages;
  final String? currentUserId;
  final UserModel? companion;
  final Function(int, LongPressStartDetails) onLongPressStart;

  const MessageList({super.key,
    required this.scrollController,
    required this.messages,
    required this.currentUserId,
    required this.companion,
    required this.onLongPressStart,
  });

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      reverse: true,
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        bool isSenderMe = messages[index].senderId == currentUserId;
        return GestureDetector(
          onLongPressStart: (LongPressStartDetails details) {
            onLongPressStart(index, details);
          },
          child: MessageView(
            isSenderMe: isSenderMe,
            companion: companion,
            messages: messages,
            index: index,
            status: messages[index].status,
          ),
        );
      },
    );
  }
}
