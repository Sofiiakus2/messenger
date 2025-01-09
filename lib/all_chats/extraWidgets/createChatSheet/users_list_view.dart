import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messanger/repositories/auth_local_storage.dart';

import '../../../controllers/chat_controller.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/chat_repository.dart';
import '../../../theme.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({
    super.key,
    required this.users,
  });

  final List<UserModel> users;

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  String? currentUserId ;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async{
    currentUserId = await AuthLocalStorage().getUserId();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(top: 5),
      width: screenSize.width,
      color: thirdColor.withOpacity(0.4),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () async {
                  if(widget.users[index].id != currentUserId) {
                    ChatModel chat = await ChatRepository()
                        .getOrCreateChat(widget.users[index].id!);
                    Get.toNamed('/chat', arguments: {'chatId': chat.id})
                        ?.then((_) {
                      Get.find<ChatController>().fetchUserChats();
                    });
                  }
                },
                child: Container(
                  height: 60,
                  margin: EdgeInsets.only(left: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_outline_rounded, color: thirdColor, size: 28),
                      ),
                      SizedBox(width: 10),
                      Text(
                        widget.users[index].id == currentUserId
                          ? 'Ви'
                          : widget.users[index].name,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: widget.users[index].id == currentUserId
                                ? Colors.black
                                : Colors.white
                          ))
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.white),
            ],
          );
        },
      ),
    );
  }
}