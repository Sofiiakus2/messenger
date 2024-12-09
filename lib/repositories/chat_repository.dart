import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<ChatModel> getOrCreateChat(String userId) async {
    User? currentUser = auth.currentUser;
    ChatModel? chat = await findChat(userId, currentUser!.uid);

    if (chat != null) {
      return chat;
    } else {
      return await createChat(userId, currentUser.uid);
    }
  }

  Future<ChatModel?> findChat(String userId, String currentUserId) async {
    final querySnapshot = await firestore
        .collection('chats')
        .where('companionsIds', arrayContains: currentUserId)
        .get();

    for (var doc in querySnapshot.docs) {
      ChatModel chat = ChatModel(
        id: doc.id,
        companionsIds: List<String>.from(doc.data()['companionsIds']),
        messages: (doc.data()['messages'] as List<dynamic>)
            .map((message) => MessageModel.fromMap(message))
            .toList(),
      );

      if (chat.companionsIds.contains(userId)) {
        return chat;
      }
    }

    return null;
  }


  Future<ChatModel> createChat(String userId, String currentUserId) async {
    ChatModel newChat = ChatModel(
      id: '',
      companionsIds: [currentUserId, userId],
      messages: [],
    );

    final docRef = await firestore.collection('chats').add({
      'companionsIds': newChat.companionsIds,
      'messages': [],
    });

    newChat.id = docRef.id;

    return newChat;
  }

}