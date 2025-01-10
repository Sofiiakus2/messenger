import 'package:flutter/material.dart';
import 'package:messanger/personal_chat/extraWidgets/chat_details/extraWidgets/add_user_selection.dart';

import '../../../../theme.dart';

class AddNewMemberButton extends StatelessWidget {
  const AddNewMemberButton({
    super.key, required this.chatId, required this.resetUsers,
  });

  final String chatId;
  final Function resetUsers;


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return AddUserSelection(
              chatId: chatId,
            );
          },
        ).then((value){
          resetUsers();
        });
      },
      child: Container(
        width: screenSize.width,
        height: 70,
        margin: EdgeInsets.only(top: 7),
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: thirdColor.withOpacity(0.4),
        child: Row(
          children: [
            Icon(Icons.person_add_outlined, size: 36, color: secondaryColor,),
            SizedBox(width: 20,),
            Text('Додати нового учасника', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: secondaryColor),)
          ],
        ),
      ),
    );
  }
}
