import 'package:flutter/material.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../../../models/user_model.dart';
import '../../../theme.dart';

class NewGroupCreatingSettings extends StatefulWidget {
  final bool showCreatingSettings;
  final Function onBackPressed;
  final Function onClose;
  final Map<UserModel, bool> selectedUsers;

  const NewGroupCreatingSettings({super.key, 
    required this.showCreatingSettings,
    required this.onBackPressed,
    required this.onClose,
    required this.selectedUsers
  });

  @override
  State<NewGroupCreatingSettings> createState() => _NewGroupCreatingSettingsState();
}

class _NewGroupCreatingSettingsState extends State<NewGroupCreatingSettings> {
  TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        right: widget.showCreatingSettings ? 0 : -screenSize.width,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      onPressed: () async{
                       if(groupNameController.text.isNotEmpty){
                          List<String> userIds = widget.selectedUsers.keys
                              .map((user) => user.id)
                              .where((id) => id != null)
                              .map((id) => id!)
                              .toList();
                          ChatRepository().createAndGetGroupChat(userIds, groupNameController.text);
                         widget.onClose();
                        }



                      },
                      child: Text(
                        'Створити',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: thirdColor,
                          fontWeight: FontWeight.w900,
                          decorationColor: thirdColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: screenSize.width,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: thirdColor.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: thirdColor.withOpacity(0.5),
                      child: Icon(Icons.photo_camera, color: primaryColor, size: 36,),
                    ),
                    SizedBox(width: 20,),
                    SizedBox(
                      height: 50,
                      width: 270,
                      child: TextField(
                        controller: groupNameController,
                        decoration: InputDecoration(
                          hintText: 'Назва групи',
                          hintStyle: Theme.of(context).textTheme.labelMedium,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),

                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10, left: 15),
                  child: Text('Учасники', style: Theme.of(context).textTheme.labelMedium,),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: widget.selectedUsers.length,
                    itemBuilder: (context, index){
                      var user = widget.selectedUsers.keys.elementAt(index);
                      return Container(
                        width: screenSize.width,
                        height: 60,
                        padding: EdgeInsets.only(left: 10),
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: thirdColor.withOpacity(0.3),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person_outline_rounded, color: thirdColor, size: 28),
                            ),
                            SizedBox(width: 10),
                            Text(user.name, style: Theme.of(context).textTheme.labelSmall)
                          ],
                        ),
                      );
                    }
                ),
              ),

            ],
          ),
        )
    );
  }
}
