import 'package:get/get.dart';
import 'package:messanger/models/chat_model.dart';
import 'package:messanger/models/user_model.dart';
import 'package:messanger/repositories/chat_repository.dart';

import '../repositories/user_repository.dart';

class ChatController extends GetxController {
  var chats = <ChatModel>[].obs;
  var companions = <String, UserModel>{}.obs;
  var favouriteUsers = <UserModel>[].obs;
  var filteredChats = <ChatModel>[].obs;
  var searchQuery = ''.obs;


  Future<void> fetchUserChats() async {
    final chatIds = await ChatRepository().getChatIdsByUserId().first;
    final chatFutures = chatIds.map(
            (id) => ChatRepository()
            .getChatByIdWithoutMessages(id)
            .catchError((_) => null)
    );
    final results = await Future.wait(chatFutures);

    final filteredChats = results.whereType<ChatModel>().toList();

    final companionFutures = <Future<MapEntry<String, UserModel>>>[];
    for (var chat in filteredChats) {
      companionFutures.add(
        UserModel.getChatCompanion(chat).then((companionUser) => MapEntry(chat.id, companionUser!)),
      );
    }

    final companionsData = await Future.wait(companionFutures);

    filteredChats.sort((a, b) {
      if (a.lastMessageTime == null || b.lastMessageTime == null) {
        return 0;
      }
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });

    chats.assignAll(filteredChats);
    companions.assignAll(Map.fromEntries(companionsData));

 }

  Future<void> fetchFavouriteUsers() async {
    List<String> favUsers = await UserRepository().getFavoriteContacts();

    if (favUsers.isNotEmpty) {
      favouriteUsers.value = await UserRepository().getUsersByIds(favUsers);
    } else {
      favouriteUsers.value = [];
    }
  }

  void filterChats(String query) {

    searchQuery.value = query;
    if (query.isEmpty) {
      filteredChats.assignAll(chats);
    } else {
      final lowerCaseQuery = query.toLowerCase();
      final filtered = chats.where((chat) {
        final companionName = companions[chat.id]?.name.toLowerCase() ?? '';
        final chatName = chat.name?.toLowerCase() ?? '';
        return companionName.contains(lowerCaseQuery) || chatName.contains(lowerCaseQuery);
      }).toList();
      filteredChats.assignAll(filtered);
    }
  }


  @override
  void onInit() {
    fetchUserChats();
    fetchFavouriteUsers();
    super.onInit();
  }
}
