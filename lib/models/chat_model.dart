import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messanger/models/message_model.dart';

class ChatModel{
  String id;
  List<String> companionsIds;
  List<MessageModel>? messages;
  String? lastMessage;
  DateTime? lastMessageTime;
  bool? lastMessageSender;

  ChatModel({
    required this.id,
    required this.companionsIds,
    this.messages,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSender,
});





}
