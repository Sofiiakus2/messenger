import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/chat_controller.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
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
    try {
      final querySnapshot = await firestore
          .collection('chats')
          .where('companionsIds', arrayContains: currentUserId)
          .get();

      for (var doc in querySnapshot.docs) {
        ChatModel chat = ChatModel(
          id: doc.id,
          companionsIds: List<String>.from(doc.data()['companionsIds']),
        );

        if (chat.companionsIds.length == 2 && chat.companionsIds.contains(userId)) {
          return chat;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }


  Future<void> updateEditProfileData({
    required String chatId,
    required bool editProfileData,
  }) async {
    try {
      final chatCollection = FirebaseFirestore.instance.collection('chats');

      await chatCollection.doc(chatId).update({
        'editProfileData': editProfileData,
      });

    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAddNewMember({
    required String chatId,
    required bool addNewMember,
  }) async {
    try {
      final chatCollection = FirebaseFirestore.instance.collection('chats');

      await chatCollection.doc(chatId).update({
        'addNewMember': addNewMember,
      });

    } catch (e) {
      rethrow;
    }
  }




  Future<ChatModel> createChat(String userId, String currentUserId) async {
    ChatModel newChat = ChatModel(
      id: '',
      companionsIds: [currentUserId, userId],
      isGroup: false,
      messages: []
    );

    final docRef = await firestore.collection('chats').add({
      'companionsIds': newChat.companionsIds,
    });

    newChat.id = docRef.id;

    await addChatIdToUsers(newChat.id, newChat.companionsIds);

    return newChat;
  }

  Future<ChatModel> createAndGetGroupChat(List<String> userIds, String name)async{
    String newChatId = await ChatRepository().createGroupChat(userIds, name);

    MessagesRepository().sendDefoltMessage(newChatId);

    ChatModel? chat = await ChatRepository().getChatById(newChatId);

    final chatController = Get.find<ChatController>();
    chatController.chats.insert(0, chat!);

    return chat;
  }


  Future<String> createGroupChat(List<String> userIds, String name) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    List<String> companionsIds = [...userIds, currentUserId];

    final docRef = await firestore.collection('chats').add({
      'companionsIds': companionsIds,
      'owner': currentUserId,
      'isGroup' : true,
      'name':name,
      'editProfileData': false,
      'addNewMember': false,
    });

    await addChatIdToUsers(docRef.id, companionsIds);

    return docRef.id;
  }

  Future<void> updateChatName(String chatId, String newName) async {
    try {
      await firestore.collection('chats').doc(chatId).update({
        'name': newName,
      });
    } catch (e) {
      print("Error updating chat name: $e");
    }
  }


  Future<void> deleteChat(String chatId) async {
    try {
      final chatDocRef = firestore.collection('chats').doc(chatId);

      final chatDoc = await chatDocRef.get();
      if (!chatDoc.exists) {
        throw Exception("Чат з ID $chatId не знайдено");
      }

      final messagesQuerySnapshot = await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      for (final messageDoc in messagesQuerySnapshot.docs) {
        await messageDoc.reference.delete();
      }

      await chatDocRef.delete();

    } catch (e) {
      rethrow;
    }
  }


  Future<void> addUsersToExistingChat(String chatId, Map<UserModel, bool> selectedUsers) async {
    try {
      final docRef = firestore.collection('chats').doc(chatId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<dynamic> existingCompanions = docSnapshot.data()?['companionsIds'] ?? [];

        List<String?> newUserIds = selectedUsers.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key.id)
            .where((id) => !existingCompanions.contains(id))
            .toList();

        List<String?> updatedCompanions = [
          ...existingCompanions.cast<String>(),
          ...newUserIds,
        ];

        MessageModel newMessage = MessageModel(
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: 'До чату було додано нових користувачів',
            time: DateTime.now() ,
            status: false,
            isEdited: false,
            messageType: MessageType.noti
        );

        await docRef.update({'companionsIds': updatedCompanions});
        await MessagesRepository().sendMessage(chatId, newMessage);
      } else {
        throw Exception("Чат із ID $chatId не знайдено.");
      }
    } catch (e) {
      throw Exception("Не вдалося оновити список companionsIds.");
    }
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
      rethrow;
    }
  }

  Stream<List<String>> getChatIdsByUserId() {
    User? currentUser = auth.currentUser;
    return firestore
        .collection('chats')
        .where('companionsIds', arrayContains: currentUser!.uid)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) => doc.id).toList());
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
          isGroup: data['isGroup'] ?? false,
          name: data['name'] ?? '',
          lastMessage: lastMessage!.text ?? '',
          lastMessageTime: lastMessage.time,
          lastMessageSender: lastMessage.senderId == currentUser!.uid
            ? true
              : false
        );
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<ChatModel?> getChatById(String chatId) async {
    try {
      final chatDoc = await firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        return null;
      }

      final chatData = chatDoc.data() as Map<String, dynamic>;
      final companionsIds = List<String>.from(chatData['companionsIds']);

      final messageSnapshot = await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('time', descending: true)
          .limit(100)
          .get();


      final messages = messageSnapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data(), doc.id))
          .toList();


      final lastMessage = messages.isNotEmpty ? messages.first.text : null;
      final lastMessageTime = messages.isNotEmpty ? messages.first.time : null;

      return ChatModel(
        id: chatId,
        companionsIds: companionsIds,
        messages: messages,
        isGroup: chatData['isGroup'] ?? false,
        name:  chatData['name'] ?? '',
        owner: chatData['owner'] ?? '',
        editProfileData: chatData['editProfileData'] ?? false,
        addNewMember: chatData['addNewMember'] ?? false,
        lastMessage: lastMessage,
        lastMessageTime: lastMessageTime,
        lastMessageSender: messages.isNotEmpty
            ? messages.first.senderId ==
            chatData['senderId']
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }



}