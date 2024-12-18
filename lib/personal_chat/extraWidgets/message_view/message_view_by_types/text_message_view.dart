import 'package:flutter/material.dart';
import 'package:messanger/personal_chat/extraWidgets/message_view/message_view_by_types/reply_message_view.dart';

import '../../../../models/message_model.dart';
import '../../../../theme.dart';

class TextMessageView extends StatelessWidget {
  const TextMessageView({super.key, required this.message});
  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(message.replyMessage != null)
          ReplyMessageView(message: message.replyMessage!,),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            message.text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.black),
          ),
        ),
        if(message.isEdited)
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: Text(
                'Змінено',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: primaryColor),
              ),
            ),
          ),
      ],
    );
  }
}
