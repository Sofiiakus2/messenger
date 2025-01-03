import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messanger/models/message_model.dart';

class MessagesRepository{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, MessageModel newMessage) async {
    try {
      final messageRef = firestore.collection('chats').doc(chatId).collection('messages');
      await messageRef.add(newMessage.toMap());

    } catch (e) {
      rethrow;
    }
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

  Future<void> updateMessage(
    String chatId,
    String messageId,
    String updatedText,
  ) async {
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