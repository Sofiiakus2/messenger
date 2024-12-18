import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/models/chat_model.dart';
import 'package:messanger/personal_chat/personal_chat_page.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';
import '../../theme.dart';

class ForwardBottomDrawer extends StatefulWidget {
  const ForwardBottomDrawer({super.key, required this.forwardMessage});

  final MessageModel forwardMessage;

  @override
  State<ForwardBottomDrawer> createState() => _ForwardBottomDrawerState();
}

class _ForwardBottomDrawerState extends State<ForwardBottomDrawer> {
  List<UserModel> users = [];

  void fetchUsers() async {
    final fetchedUsers = await UserRepository().getAllUsers();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.reply_sharp, color: Colors.black),
              Text('Переслати', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),),
              TextButton(
                onPressed: (){
                  Get.back();
                },
                child:Text('Скасувати', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: thirdColor, decoration: TextDecoration.underline),),
              ),
            ],
          ),
          const Divider( color: primaryColor,),
          Container(
            height: 340,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () async{
                        Get.back();
                        ChatModel? chat = await ChatRepository().getOrCreateChat(users[index].id!);
                        Get.to(() => const PersonalChatPage(), arguments: {
                          'chatId': chat.id,
                          'forwardMessage': widget.forwardMessage,
                        });
                        },
                      child: Row(
                        children: [
                          CircleAvatar(radius: 34, backgroundColor: Colors.grey[200]),
                          const SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(users[index].name, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),),
                              Text('В мережі 1 годину тому', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black),),

                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(color: primaryColor,)
                  ],
                );
              },

            ),
          )
        ],
      ),
    );
  }
}
