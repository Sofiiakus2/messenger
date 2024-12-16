import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messanger/models/message_model.dart';
import 'package:uuid/uuid.dart';

class MessagesRepository{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, MessageModel newMessage) async {
    try {
      final messageRef = firestore.collection('chats').doc(chatId).collection('messages');
      await messageRef.add(newMessage.toMap());
      // await messageRef.add({
      //   'id': const Uuid().v4(),
      //   'senderId': newMessage.senderId,
      //   'text': newMessage.text,
      //   'time': newMessage.time,
      //   'status': newMessage.status,
      //   'replyMessage' : newMessage.replyMessage
      // });
    } catch (e) {
      print("Error sending message: $e");
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
        final lastMessageData = messageSnapshot.docs.first.data();
        return MessageModel.fromMap(lastMessageData);
      }
    } catch (e) {
      print('Error fetching last message by chat ID: $e');
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

      print('Message with id $messageId has been deleted.');
    } catch (e) {
      print('Error deleting message: $e');
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
      print("Message updated successfully");
    } catch (e) {
      print("Error updating message: $e");
    }
  }


}