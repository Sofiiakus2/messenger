import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/models/chat_model.dart';

class ChatBar extends StatelessWidget {
  const ChatBar({super.key, required this.chat, required this.userName});
  final ChatModel? chat;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed('/chatDetails', arguments: {'chat': chat});
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child:
            chat?.isGroup!=null && chat?.isGroup == true
                ? Text(
              chat!.name.toString(),
              style: Theme.of(context).textTheme.labelMedium,
            )
                : Text(
              userName,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Text(
            'Online',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
