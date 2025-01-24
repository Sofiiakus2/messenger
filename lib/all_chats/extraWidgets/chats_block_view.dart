import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/chat_controller.dart';
import '../../models/chat_model.dart';
import '../../models/message_model.dart';

class ChatsBlockView extends StatelessWidget {
  const ChatsBlockView({
    super.key,
    required this.chatController, required this.chats, required this.isMessageNeed,
  });

  final ChatController chatController;
  final List<ChatModel> chats;
  final bool isMessageNeed;

  @override
  Widget build(BuildContext context) {
    final companions = chatController.companions;
    final screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        final companion = companions[chat.id];
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed('/chat', arguments: {'chatId': chat.id})?.then((_) {
                  chatController.fetchUserChats();
                  chatController.fetchFavouriteUsers();
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    CircleAvatar(radius: isMessageNeed
                        ? 34
                        : 26
                    , backgroundColor: Colors.grey[200]),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          chat.isGroup!=null && chat.isGroup == true
                              ? Text(
                            chat.name ?? 'Loading...',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isMessageNeed
                                ? Colors.black
                                : Colors.white),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          )
                              : Text(
                            companion?.name ?? 'Loading...',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isMessageNeed
                                    ? Colors.black
                                    : Colors.white),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                          if(isMessageNeed == true)
                          Text(
                            chat.lastMessage ?? 'Новий чат',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if(isMessageNeed == true)
                    Text(
                      chat.lastMessageTime != null ? formatLastMessageTime(chat.lastMessageTime!) : formatLastMessageTime(DateTime.now()),

                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
            if(isMessageNeed == false)
            Container(
                width: screenSize.width,
                padding: EdgeInsets.only(bottom: 10),
                child: Divider(color: Colors.grey[200],)
            ),
          ],
        );
      },
    );
  }
}