import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/chat_controller.dart';
import 'chats_block_view.dart';

class AllChats extends StatelessWidget {
  const AllChats({super.key, required this.isFavEmpty});
  final bool isFavEmpty;

  @override
  Widget build(BuildContext context) {
    final chatController = Get.put(ChatController());

    return Obx(() {
      return Padding(
        padding: EdgeInsets.only(
            top: isFavEmpty
              ? 180
              : 10
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: isFavEmpty
              ? MediaQuery.of(context).size.height * 0.65
              :MediaQuery.of(context).size.height * 0.82,
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
          child: chatController.chats.isEmpty
            ? Center(child: Text('У вас ще немає чатів', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),),)
         : ChatsBlockView(
            chatController: chatController,
            chats: chatController.chats,
            isMessageNeed: true,
          ),
        ),
      );
    });
  }
}

