import 'package:flutter/material.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/new_group_creating_settings.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/selectedUsersWrap/selected_users_block.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/user_selection_list.dart';

import '../../../models/user_model.dart';
import '../../../theme.dart';

class NewGroupWidget extends StatefulWidget {
  final bool showNewGroup;
  final Size screenSize;
  final Map<UserModel, bool> selectedUsers;
  final Function(UserModel) onUserTap;
  final Function onBackPressed;

  const NewGroupWidget({super.key, 
    required this.showNewGroup,
    required this.screenSize,
    required this.selectedUsers,
    required this.onUserTap,
    required this.onBackPressed,
  });

  @override
  State<NewGroupWidget> createState() => _NewGroupWidgetState();
}

class _NewGroupWidgetState extends State<NewGroupWidget> {
  bool showCreatingSettings = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: screenSize.height - 100,
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          right: widget.showNewGroup ? 0 : -widget.screenSize.width,
          top: 0,
          bottom: 0,
          child: Container(
            width: screenSize.width,
            height: screenSize.height - 100,
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
                          widget.onBackPressed();
                        },
                      ),
                      Text(
                        'Нова група',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showCreatingSettings = true;
                          });
                        },
                        child: Text(
                          'Далі',
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
                SelectedUsersBlock(selectedUsers: widget.selectedUsers),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 5),
                    width: screenSize.width,
                    color: thirdColor.withOpacity(0.4),
                    child: UserSelectionList(
                      selectedUsers: widget.selectedUsers,
                      onUserTap: widget.onUserTap,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
        NewGroupCreatingSettings(
            showCreatingSettings: showCreatingSettings,
          selectedUsers: widget.selectedUsers,
          onBackPressed: () {
            setState(() {
              showCreatingSettings = false;
            });
          },
          onClose:  () {
            setState(() {
              showCreatingSettings = false;
              widget.onBackPressed();
            });
          },
        )
      ],
    );
  }
}
