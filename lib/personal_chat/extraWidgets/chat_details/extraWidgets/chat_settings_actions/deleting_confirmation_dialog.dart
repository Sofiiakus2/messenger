import 'package:flutter/material.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../../../../../theme.dart';


class DeletingConfirmationDialog extends StatelessWidget {

  final String chatId;

  const DeletingConfirmationDialog({
    super.key,
    required this.chatId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Підтвердження", style: Theme.of(context).textTheme.titleMedium,),
      content: Text(
            "Ви впевнені що хочете видалити чат?",
        style: Theme.of(context).textTheme.titleMedium,),
      backgroundColor: primaryColor,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Скасувати", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: thirdColor),),
        ),
        ElevatedButton(
          onPressed: () async {
            await ChatRepository().deleteChat(chatId);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(secondaryColor),
          ),
          child: Text("Підтвердити", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: thirdColor),),
        ),
      ],
    );
  }
}
