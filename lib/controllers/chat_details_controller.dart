import 'package:get/get.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';

class ChatDetailsController extends GetxController {
  var chat = Rxn<ChatModel>();
  var usersGroupList = <UserModel>[].obs;

  Future<void> loadChatData(ChatModel chatModel) async {
    chat.value = chatModel;

    usersGroupList.value =
    await UserRepository().getUsersByIds(chatModel.companionsIds);
    }

  Future<void> resetUsers() async {
    if (chat.value != null) {
      chat.value!.companionsIds = ['newUserId1', 'newUserId2'];
      
      usersGroupList.value =
      await UserRepository().getUsersByIds(chat.value!.companionsIds);
    }
  }
}
