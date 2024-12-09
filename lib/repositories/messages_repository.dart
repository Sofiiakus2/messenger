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
            'time': newMessage.time.toIso8601String(),  // Convert DateTime to String
            'status': newMessage.status,
          }
        ]),
      });

    } catch (e) {
      print("Error sending message: $e");
    }
  }
}