import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messanger/models/message_model.dart';

class MessagesRepository{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<DocumentReference> sendMessage(String chatId, MessageModel newMessage) async {
    try {
      final messageRef = firestore.collection('chats').doc(chatId).collection('messages').doc();
      newMessage.id = messageRef.id;
      await messageRef.set(newMessage.toMap());

      return messageRef;
    } catch (e) {
      rethrow;
    }
  }


  Future<void>sendDefoltMessage(String chatId)async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    MessageModel newMessage = MessageModel(
        senderId: currentUserId,
        text: 'Вас додали до чату',
        time: DateTime.now() ,
        status: false,
        isEdited: false,
        messageType: MessageType.noti
    );

    await MessagesRepository().sendMessage(chatId, newMessage);

  }


  Future<MessageModel?> getLastMessageByChatId(String chatId) async {
    try {
      final messageSnapshot = await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('time', descending: true)
          .limit(1)
          .get();


      if (messageSnapshot.docs.isNotEmpty) {
        final lastMessageData = messageSnapshot.docs.first;
        return MessageModel.fromMap(lastMessageData.data(), lastMessageData.id);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      final messageRef = firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      await messageRef.delete();

    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMessage(String chatId, String messageId, String updatedText) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .update({
        'text': updatedText,
        'isEdited': true,
      });
    } catch (e) {
      rethrow;
    }
  }


}