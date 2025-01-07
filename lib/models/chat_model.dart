import 'package:messanger/models/message_model.dart';

class ChatModel{
  String id;
  List<String> companionsIds;
  List<MessageModel>? messages;
  String? lastMessage;
  DateTime? lastMessageTime;
  bool? lastMessageSender;
  String? name;
  bool? isGroup;

  ChatModel({
    required this.id,
    required this.companionsIds,
    this.messages,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSender,
    this.name,
    this.isGroup
});





}
