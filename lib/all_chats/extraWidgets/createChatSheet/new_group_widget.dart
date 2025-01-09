import 'package:flutter/material.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/new_group_creating_settings.dart';

import '../../../models/user_model.dart';
import '../../../theme.dart';

class NewGroupWidget extends StatefulWidget {
  final bool showNewGroup;
  final Size screenSize;
  final Map<UserModel, bool> selectedUsers;
  final List<UserModel> users;
  final Function(UserModel) onUserTap;
  final Function onBackPressed;

  const NewGroupWidget({
    required this.showNewGroup,
    required this.screenSize,
    required this.selectedUsers,
    required this.users,
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
            width: widget.screenSize.width,
            height: widget.screenSize.height - 100,
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
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top: 5, left: 10, bottom: 5),
                  width: widget.screenSize.width,
                 // height: 50,
                  color: thirdColor.withOpacity(0.4),
                  child: widget.selectedUsers.isEmpty
                      ? Text('Ви ще нікого не обрали', style: Theme.of(context).textTheme.labelSmall,)
                      : Wrap(
                    children: widget.selectedUsers.entries.map((entry) {
                      //final userId = entry.key;
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
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.only(top: 5),
                    width: widget.screenSize.width,
                    color: thirdColor.withOpacity(0.4),
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: widget.users.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {

                              },
                              child: Container(
                                height: 60,
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        widget.onUserTap(widget.users[index]);
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          color: widget.selectedUsers[widget.users[index]] ?? false ? thirdColor : Colors.transparent,
                                          border: Border.all(color: Colors.white, width: 2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: widget.selectedUsers[widget.users[index]] ?? false
                                            ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person_outline_rounded, color: thirdColor, size: 28),
                                    ),
                                    SizedBox(width: 10),
                                    Text(widget.users[index].name, style: Theme.of(context).textTheme.labelSmall),
                                  ],
                                ),
                              ),
                            ),
                            Divider(color: Colors.white),
                          ],
                        );
                      },
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
              print('11111111111111');
              widget.onBackPressed();
              print('22222222222222');
            });
          },
        )
      ],
    );
  }
}
