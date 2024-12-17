import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/models/message_model.dart';
import '../../controllers/chat_controller.dart';

class AllChats extends StatelessWidget {
  const AllChats({super.key});

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());

    return Obx(() {
      final chats = chatController.chats;
      final companions = chatController.companions;

      chats.sort((a, b) {
        if (a.lastMessageTime == null || b.lastMessageTime == null) {
          return 0;
        }
        return b.lastMessageTime!.compareTo(a.lastMessageTime!);
      });

      return Padding(
        padding: const EdgeInsets.only(top: 180),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.65,
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final companion = companions[chat.id];

              return GestureDetector(
                onTap: () {
                  Get.toNamed('/chat', arguments: {'chatId': chat.id})?.then((_) {
                    chatController.fetchUserChats();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 34, backgroundColor: Colors.grey[200]),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              companion?.name ?? 'Loading...',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w900, color: Colors.black),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                            Text(
                              chat.lastMessage ?? '',
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
      );
    });
  }
}
