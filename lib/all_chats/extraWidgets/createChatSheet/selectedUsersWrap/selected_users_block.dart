import 'package:flutter/material.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/selectedUsersWrap/selected_users_wrap.dart';

import '../../../../models/user_model.dart';
import '../../../../theme.dart';


class SelectedUsersBlock extends StatelessWidget {
  const SelectedUsersBlock({
    super.key,
    required this.selectedUsers,
  });

  final Map<UserModel, bool> selectedUsers;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
      width: screenSize.width,
      // height: 50,
      color: thirdColor.withOpacity(0.4),
      child: selectedUsers.isEmpty
          ? Text('Ви ще нікого не обрали', style: Theme.of(context).textTheme.labelSmall,)
          : SelectedUsersWrap(selectedUsers: selectedUsers),
    );
  }
}

