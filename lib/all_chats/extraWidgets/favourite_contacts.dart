import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/controllers/chat_controller.dart';
import 'package:messanger/models/user_model.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../../models/chat_model.dart';
import '../../repositories/user_repository.dart';
import '../../theme.dart';

class FavouriteContacts extends StatefulWidget {
  const FavouriteContacts({
    super.key,
  });

  @override
  State<FavouriteContacts> createState() => _FavouriteContactsState();
}

class _FavouriteContactsState extends State<FavouriteContacts> {

  String formatName(String name) {
    if (name.contains(' ')) {
      return '${name.split(' ')[0]}...';
    } else if (name.length > 6) {
      return '${name.substring(0, 6)}...';
    } else {
      return name;
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final chatController = Get.put(ChatController());

    return Obx(() {
      final users = chatController.favouriteUsers;

        return Container(
          width: screenSize.width,
          height: 250,
          decoration: const BoxDecoration(
            color: primaryColor,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, top: 20, bottom: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Улюблені контакти', style: Theme
                        .of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.bold,),),
                    const Icon(Icons.more_horiz)
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      print(users[index].name);
                      return GestureDetector(
                        onTap: () async {
                          ChatModel chat = await ChatRepository()
                              .getOrCreateChat(users[index].id!);
                          Get.toNamed('/chat', arguments: {'chatId': chat.id})
                              ?.then((_) {
                            Get.find<ChatController>().fetchUserChats();
                            Get.find<ChatController>().fetchFavouriteUsers();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 34,
                                //backgroundImage: NetworkImage(favouriteUsers[index]!),
                                backgroundColor: Colors.grey[200],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatName(users[index].name),
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .labelSmall,
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        );
    });
  }
}
