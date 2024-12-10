import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'messages_repository.dart';

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

    await addChatIdToUsers(newChat.id, newChat.companionsIds);

    return newChat;
  }

  Future<void> addChatIdToUsers(String chatId, List<String> userIds) async {
    try {
      for (String userId in userIds) {
        final userRef = firestore.collection('users').doc(userId);

        await firestore.runTransaction((transaction) async {
          final snapshot = await transaction.get(userRef);

          if (snapshot.exists) {
            final data = snapshot.data() as Map<String, dynamic>;
            List<String> chats = List<String>.from(data['chats'] ?? []);

            if (!chats.contains(chatId)) {
              chats.add(chatId);
              transaction.update(userRef, {'chats': chats});
            }
          } else {
            transaction.set(userRef, {'chats': [chatId]}, SetOptions(merge: true));
          }
        });
      }
    } catch (e) {
      print('Error adding chat ID to users: $e');
    }
  }

  Future<List<String>> getChatIdsByUserId() async {
    User? currentUser = auth.currentUser;
    try {
      final querySnapshot = await firestore
          .collection('chats')
          .where('companionsIds', arrayContains: currentUser!.uid)
          .get();

      return querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching chat IDs: $e');
      return [];
    }
  }

  Future<ChatModel?> getChatByIdWithoutMessages(String chatId) async {
    User? currentUser = auth.currentUser;
    try {
      final docSnapshot = await firestore.collection('chats').doc(chatId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final lastMessage = await MessagesRepository().getLastMessageByChatId(docSnapshot.id);

        return ChatModel(
          id: docSnapshot.id,
          companionsIds: List<String>.from(data['companionsIds']),
          messages: [],
          lastMessage: lastMessage!.text ?? '',
          lastMessageTime: lastMessage.time,
          lastMessageSender: lastMessage.senderId == currentUser!.uid
            ? true
              : false
        );
      }
    } catch (e) {
      print('Error fetching chat by ID: $e');
    }
    return null;
  }

  Future<ChatModel?> getChatById(String chatId) async{
    try{
      final chatDoc = await firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        return null;
      }

      final chatData = chatDoc.data() as Map<String, dynamic>;
      final messagesList = List<Map<String, dynamic>>.from(chatData['messages'] ?? []);

      final messages = messagesList
          .map((messageData) => MessageModel.fromMap(messageData))
          .toList();

      final limitedMessages = messages.length > 100 ? messages.take(100).toList() : messages;

      final lastMessage = limitedMessages.isNotEmpty ? limitedMessages.first.text : null;
      final lastMessageTime = limitedMessages.isNotEmpty ? limitedMessages.first.time : null;

      return ChatModel(
        id: chatId,
        companionsIds: List<String>.from(chatData['companionsIds']),
        messages: messages,
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
        lastMessageSender: messages.isNotEmpty
            ? messages.first.senderId ==
            chatData['senderId']
            : null,
      );
    }catch(e){
      print('Error fetching chat by ID: $e');
      return null;
    }
  }

  Future<List<MessageModel>> fetchMoreMessages(String chatId, DateTime lastMessageTime) async {
    try {
      final messagesQuery = await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('time', descending: true)
          .startAfter([lastMessageTime])
          .limit(100)
          .get();

      return messagesQuery.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching more messages: $e');
      return [];
    }
  }


}