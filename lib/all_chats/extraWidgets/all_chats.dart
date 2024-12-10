import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/models/message_model.dart';
import '../../models/chat_model.dart';
import '../../models/user_model.dart';
import '../../repositories/chat_repository.dart';

class AllChats extends StatefulWidget {
  const AllChats({
    super.key,
  });

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {
  List<ChatModel> chats = [];
  Map<String, UserModel> companions = {};

  // void getUserChats(String currentUserId) {
  //   userChats = chats.where((chat) => chat.companionsIds.contains(currentUserId)).toList();
  //
  //   userChats.sort((a, b) {
  //     MessageModel? lastMessageA = ChatModel.getLastMessage(a);
  //     MessageModel? lastMessageB = ChatModel.getLastMessage(b);
  //
  //     if (lastMessageA != null && lastMessageB != null) {
  //       return lastMessageB.time.compareTo(lastMessageA.time); // Відсортовуємо за спаданням часу
  //     }
  //     return 0;
  //   });
  //
  //   setState(() {});
  // }

  void fetchUserChats() async {
    final chatIds = await ChatRepository().getChatIdsByUserId();

    final chatFutures = chatIds.map((id) => ChatRepository().getChatByIdWithoutMessages(id));
    final results = await Future.wait(chatFutures);

    final filteredChats = results.whereType<ChatModel>().toList();

    final companionFutures = <Future<MapEntry<String, UserModel>>>[];
    for (var chat in filteredChats) {
      companionFutures.add(
        UserModel.getChatCompanion(chat).then((companionUser) => MapEntry(chat.id, companionUser!)),
      );
    }

    final companionsData = await Future.wait(companionFutures);

    setState(() {
      chats = filteredChats;
      companions = Map.fromEntries(companionsData);
    });
  }


  @override
  void initState() {
    //getUserChats('0');
    fetchUserChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 180),
      child: Container(
        width: screenSize.width,
        height: screenSize.height * 0.65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Container(
          width: screenSize.width,
          margin: const EdgeInsets.only(left: 30, right: 20),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final companion = companions[chat.id];
              return GestureDetector(
                onTap: (){
                  Get.toNamed('/chat', arguments: {'chatId': chat.id});
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                      //  backgroundImage: NetworkImage(companion!.image!),
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companion!.name,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                            Text(
                              chat.lastMessage!,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatLastMessageTime(chat.lastMessageTime!),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
