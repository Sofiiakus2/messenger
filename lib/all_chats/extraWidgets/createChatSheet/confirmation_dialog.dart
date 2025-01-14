import 'package:flutter/material.dart';
import 'package:messanger/repositories/user_repository.dart';
import '../../../theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String name;
  final String chatId;
  final String userId;

  const ConfirmationDialog({
    Key? key,
    required this.name,
    required this.chatId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Підтвердження", style: Theme.of(context).textTheme.titleMedium,),
      content: Text("Видалити користувача $name з чату?", style: Theme.of(context).textTheme.titleMedium,),
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
            await UserRepository().removeUserFromChat(chatId, userId);
            await UserRepository().removeChatFromUser(chatId, userId);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
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
