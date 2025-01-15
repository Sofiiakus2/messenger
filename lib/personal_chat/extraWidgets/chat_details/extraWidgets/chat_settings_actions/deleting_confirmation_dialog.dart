import 'package:flutter/material.dart';
import 'package:messanger/repositories/chat_repository.dart';
import 'package:messanger/repositories/user_repository.dart';

import '../../../../../theme.dart';


class DeletingConfirmationDialog extends StatelessWidget {

  final String chatId;

  const DeletingConfirmationDialog({
    Key? key,
    required this.chatId,
  }) : super(key: key);

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
            // bool isOwner = await UserRepository().isUserGroupOwner(userId, chatId);
            //
            // if(isOwner){
            //   await UserRepository().transferGroupOwnership(chatId, userId);
            //   await UserRepository().removeUserFromChat(chatId, userId);
            //   await UserRepository().removeChatFromUser(chatId, userId);
            //   Navigator.of(context).pop();
            // }else{
            //   await UserRepository().removeUserFromChat(chatId, userId);
            //   await UserRepository().removeChatFromUser(chatId, userId);
            // }
            // Navigator.of(context).pop();
            // Navigator.of(context).pop();

          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(secondaryColor),
          ),
          child: Text("Підтвердити", style: Theme.of(context).textTheme.titleSmall?.copyWith(color: thirdColor),),
        ),
      ],
    );
  }
}
