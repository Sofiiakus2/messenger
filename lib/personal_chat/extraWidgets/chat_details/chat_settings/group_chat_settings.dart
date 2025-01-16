import 'package:flutter/material.dart';
import 'package:messanger/personal_chat/extraWidgets/chat_details/chat_settings/custom_toggle_button.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../../../../models/chat_model.dart';
import '../../../../theme.dart';

class GroupChatSettings extends StatefulWidget {
  final ChatModel chat;
  final Function(String) onChatNameUpdated;

  const GroupChatSettings({super.key, required this.chat, required this.onChatNameUpdated,});


  @override
  State<GroupChatSettings> createState() => _GroupChatSettingsState();
}

class _GroupChatSettingsState extends State<GroupChatSettings> {
  TextEditingController groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupNameController.text = widget.chat.name!;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height - 100,
      width: screenSize.width,
      padding: EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
              ),
              Positioned(
                bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: thirdColor.withOpacity(0.8),
                    child: Icon(Icons.edit_outlined, color: Colors.white, size: 28,),
                  ),
              )
            ],
          ),
          Container(
            height: 50,
            width: screenSize.width/2,
            child: TextField(
              controller: groupNameController,
              onEditingComplete: (){
                print('complete ${groupNameController.text}');
                ChatRepository().updateChatName(widget.chat.id, groupNameController.text);

                setState(() {
                  widget.chat.name = groupNameController.text;
                });
                widget.onChatNameUpdated(groupNameController.text);
              },
              decoration: InputDecoration(
                hintText: 'Назва групи',
                hintStyle: Theme.of(context).textTheme.labelMedium,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontSize: 26,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white,
              ),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          Container(
            width: screenSize.width,
              margin: EdgeInsets.only(left: 10, top: 30),
              child: Text('Дозволи користувачів групи:', style: Theme.of(context).textTheme.titleMedium,)),
          Container(
            height: 70,
            width: screenSize.width,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10,),
            decoration: BoxDecoration(
              color: thirdColor.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Редагувати дані чату', style: Theme.of(context).textTheme.titleMedium,),
                CustomToggleButton(
                  initialValue: widget.chat.editProfileData!,
                  onToggle: (value){
                    ChatRepository().updateEditProfileData(chatId: widget.chat.id, editProfileData: value);
                    widget.chat.editProfileData = value;
                  },
                )
              ],
            ),
          ),
          Container(
            height: 70,
            width: screenSize.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10,),
            decoration: BoxDecoration(
              color: thirdColor.withOpacity(0.3),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Додавати нових користувачів', style: Theme.of(context).textTheme.titleMedium,),
                CustomToggleButton(
                  initialValue: widget.chat.addNewMember!,
                  onToggle: (value){
                    ChatRepository().updateAddNewMember(chatId: widget.chat.id, addNewMember: value);
                    widget.chat.addNewMember = value;
                  },
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
