import 'package:get/get.dart';
import 'package:messanger/models/chat_model.dart';
import 'package:messanger/models/user_model.dart';
import 'package:messanger/repositories/chat_repository.dart';

class ChatController extends GetxController {
  var chats = <ChatModel>[].obs;
  var companions = <String, UserModel>{}.obs;

  void fetchUserChats() async {
    final chatIds = await ChatRepository().getChatIdsByUserId().first;
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

    filteredChats.sort((a, b) {
      if (a.lastMessageTime == null || b.lastMessageTime == null) {
        return 0;
      }
      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
    });

    chats.assignAll(filteredChats);
    companions.assignAll(Map.fromEntries(companionsData));

    // chats.value = filteredChats;
    // companions.value = Map.fromEntries(companionsData);
  }

  @override
  void onInit() {
    fetchUserChats();
    super.onInit();
  }
}
