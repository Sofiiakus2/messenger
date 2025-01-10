import 'package:flutter/material.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../../../../all_chats/extraWidgets/createChatSheet/selectedUsersWrap/selected_users_block.dart';
import '../../../../all_chats/extraWidgets/createChatSheet/user_selection_list.dart';
import '../../../../models/user_model.dart';
import '../../../../theme.dart';

class AddUserSelection extends StatefulWidget {
  const AddUserSelection({super.key, required this.chatId});
  final String chatId;

  @override
  State<AddUserSelection> createState() => _AddUserSelectionState();
}

class _AddUserSelectionState extends State<AddUserSelection> {
  Map<UserModel, bool> selectedUsers = {};

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height - 100,
      width: screenSize.width,
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Додати',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    ChatRepository().addUsersToExistingChat(widget.chatId, selectedUsers);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Готово',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: thirdColor,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      decorationColor: thirdColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SelectedUsersBlock(selectedUsers: selectedUsers),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(top: 5),
              width: screenSize.width,
              color: thirdColor.withOpacity(0.4),
              child: UserSelectionList(
                selectedUsers: selectedUsers,
                onUserTap: (UserModel user) {
                  setState(() {
                    if (selectedUsers[user] ?? false) {
                      selectedUsers.remove(user);
                    } else {
                      selectedUsers[user] = true;
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
