import 'package:flutter/material.dart';

import '../../../../models/user_model.dart';
import '../../../../theme.dart';

class SelectedUsersWrap extends StatelessWidget {
  const SelectedUsersWrap({
    super.key,
    required this.selectedUsers,
  });

  final Map<UserModel, bool> selectedUsers;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: selectedUsers.entries.map((entry) {
        final user = entry.key;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.only(left: 2, bottom: 5, right: 2),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: secondaryColor,
              ),
              SizedBox(width: 8),
              Text(
                user.name,  // Replace with the actual user name
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
