import 'package:get/get.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';

class ChatDetailsController extends GetxController {
  var chat = Rxn<ChatModel>();
  var usersGroupList = <UserModel>[].obs;

  Future<void> loadChatData(ChatModel chatModel) async {
    chat.value = chatModel;

    if (chatModel.companionsIds != null) {
      usersGroupList.value =
      await UserRepository().getUsersByIds(chatModel.companionsIds!);
    }
  }

  Future<void> resetUsers() async {
    // Оновлюємо companionsIds (наприклад, після змін у БД)
    if (chat.value != null) {
      chat.value!.companionsIds = ['newUserId1', 'newUserId2']; // Замініть на реальні дані

      // Оновлюємо usersGroupList
      usersGroupList.value =
      await UserRepository().getUsersByIds(chat.value!.companionsIds!);
    }
  }
}
