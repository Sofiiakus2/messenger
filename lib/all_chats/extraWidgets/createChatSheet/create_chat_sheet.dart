import 'package:flutter/material.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/users_list_view.dart';

import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme.dart';
import 'new_group_widget.dart';

class CreateChatSheet extends StatefulWidget {
  const CreateChatSheet({super.key});

  @override
  State<CreateChatSheet> createState() => _CreateChatSheetState();
}

class _CreateChatSheetState extends State<CreateChatSheet> {
  List<UserModel> users = [];
  bool showNewGroup = false;
  Map<UserModel, bool> selectedUsers = {};

  void fetchUsers() async {
    final fetchedUsers = await UserRepository().getAllUsers();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            height: screenSize.height - 100,
            width: screenSize.width,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Скасувати',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: thirdColor,
                            decoration: TextDecoration.underline,
                            decorationColor: thirdColor,
                          ),
                        ),
                      ),
                      Text(
                        'Написати',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 50),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Пошук',
                      hintStyle: Theme.of(context).textTheme.labelSmall,
                      filled: true,
                      fillColor: thirdColor.withOpacity(0.4),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: screenSize.width,
                  color: thirdColor.withOpacity(0.4),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.people_outline, color: Colors.white, size: 30),
                        title: Text('Нова група', style: Theme.of(context).textTheme.labelMedium),
                        onTap: () {
                          setState(() {
                            showNewGroup = true;
                          });
                        },
                      ),
                      Divider(color: Colors.white),
                      ListTile(
                        leading: Icon(Icons.person_add_alt, color: Colors.white, size: 30),
                        title: Text('Новий контакт', style: Theme.of(context).textTheme.labelMedium),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Контакти',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: thirdColor),
                  ),
                ),
                Expanded(child: UsersListView(users: users))
              ],
            ),
          ),
        ),
        NewGroupWidget(
          showNewGroup: showNewGroup,
          screenSize: screenSize,
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
          onBackPressed: () {
            setState(() {
              showNewGroup = false;
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}


