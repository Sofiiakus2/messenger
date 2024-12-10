import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messanger/models/message_model.dart';

class MessagesRepository{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String chatId, MessageModel newMessage) async{
    try {
      final chatRef = firestore.collection('chats').doc(chatId);
      await chatRef.update({
        'messages': FieldValue.arrayUnion([
          {
            'senderId': newMessage.senderId,
            'text': newMessage.text,
            'time': newMessage.time,
            'status': newMessage.status,
          }
        ]),
      });

    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<MessageModel?> getLastMessageByChatId(String chatId) async {

    try {
      final chatDoc = await firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {

        final data = chatDoc.data()!;
        final messagesList = data['messages'] as List<dynamic>;
        final lastMessageMap = messagesList.last as Map<String, dynamic>;
        final lastMessage = MessageModel.fromMap(lastMessageMap);

        return MessageModel(
          senderId: lastMessage.senderId,
          text: lastMessage.text,
          time: lastMessage.time,
          status: false,
        );
            }
    } catch (e) {
      print('Error fetching last message by chat ID: $e');
    }
    return null;
  }

}