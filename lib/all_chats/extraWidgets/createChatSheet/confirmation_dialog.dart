import 'package:flutter/material.dart';
import 'package:messanger/repositories/user_repository.dart';
import '../../../theme.dart';

class ConfirmationDialog extends StatelessWidget {
  final String name;
  final String chatId;
  final String userId;
  final bool isCurrentUser;

  const ConfirmationDialog({
    super.key,
    required this.name,
    required this.chatId,
    required this.userId,
    required this.isCurrentUser
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Підтвердження", style: Theme.of(context).textTheme.titleMedium,),
      content: Text(
        isCurrentUser
        ?"Ви точно хочете покинути групу?"
        :"Видалити користувача $name з чату?",
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
            bool isOwner = await UserRepository().isUserGroupOwner(userId, chatId);

            if(isOwner){
              await UserRepository().transferGroupOwnership(chatId, userId);
              await UserRepository().removeUserFromChat(chatId, userId);
              await UserRepository().removeChatFromUser(chatId, userId);
              Navigator.of(context).pop();
            }else{
              await UserRepository().removeUserFromChat(chatId, userId);
              await UserRepository().removeChatFromUser(chatId, userId);
            }
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
