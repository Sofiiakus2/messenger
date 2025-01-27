import 'package:flutter/material.dart';
import '../../../models/message_model.dart';
import '../../../theme.dart';

class ReplyForwardBlock extends StatelessWidget {
  final bool isReply;
  final bool isForward;
  final MessageModel? message;
  final Function cancelEditMessage;

  const ReplyForwardBlock({
    super.key,
    required this.isReply,
    required this.isForward,
    required this.message,
    required this.cancelEditMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isReply || isForward)
          const Icon(
            Icons.reply_sharp,
            color: thirdColor,
            size: 30,
          ),
        Container(
          constraints: const BoxConstraints(
            minWidth: 60,
            maxWidth: 310,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: thirdColor.withOpacity(0.3),
            border: const Border(
              left: BorderSide(
                color: thirdColor,
                width: 3,
              ),
            ),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isForward
                    ? 'Переслане повідомлення'
                    : 'Відповісти:',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: thirdColor),
              ),
              Text(
                message!.text,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: () => cancelEditMessage(),
          icon: const Icon(
            Icons.close,
            color: thirdColor,
            size: 30,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
