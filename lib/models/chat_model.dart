import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messanger/models/message_model.dart';

class ChatModel{
  String id;
  List<String> companionsIds;
  List<MessageModel> messages;
  String? lastMessage;
  DateTime? lastMessageTime;
  bool? lastMessageSender;

  ChatModel({
    required this.id,
    required this.companionsIds,
    required this.messages,
    this.lastMessage,
    this.lastMessageTime,
    this.lastMessageSender,
});

  static MessageModel? getLastMessage(ChatModel chat) {
    if (chat.messages.isEmpty) {
      return null;
    }
    return chat.messages.last;
  }



}

List<ChatModel> chats = [
  ChatModel(
    id: '1',
    companionsIds: ['1', '0'],
    messages: [
      MessageModel(
        senderId: '1',
        text: 'Hello! How are you?',
        time: DateTime.now().subtract(Duration(minutes: 5)),
        status: true,
      ),
      MessageModel(
        senderId: '0',
        text: 'I’m good, thanks! And you?',
        time: DateTime.now().subtract(Duration(minutes: 8)),
        status: true,
      ),
      MessageModel(
        senderId: '1',
        text: 'I’m great, thanks for asking.',
        time: DateTime.now().subtract(Duration(minutes: 10)),
        status: true,
      ),
    ],
  ),
  ChatModel(
    id: '2',
    companionsIds: ['6', '0'],
    messages: [
      MessageModel(
        senderId: '6',
        text: 'How’s the project going?',
        time: DateTime.now().subtract(Duration(hours: 1)),
        status: true,
      ),
      MessageModel(
        senderId: '0',
        text: 'It’s on track, almost done!',
        time: DateTime.now().subtract(Duration(minutes: 50)),
        status: true,
      ),
      MessageModel(
        senderId: '6',
        text: 'Great to hear! Keep it up.',
        time: DateTime.now().subtract(Duration(minutes: 30)),
        status: true,
      ),
      MessageModel(
        senderId: '6',
        text: 'Let me know if you need help.',
        time: DateTime.now().subtract(Duration(minutes: 20)),
        status: true,
      ),
    ],
  ),
  ChatModel(
    id: '3',
    companionsIds: ['12', '0'],
    messages: [
      MessageModel(
        senderId: '12',
        text: 'Did you check my email?',
        time: DateTime.now().subtract(Duration(days: 1)),
        status: true,
      ),
      MessageModel(
        senderId: '0',
        text: 'Yes, I’ll reply soon.',
        time: DateTime.now().subtract(Duration(days: 1, hours: 2)),
        status: true,
      ),
      MessageModel(
        senderId: '12',
        text: 'Okay, no rush!',
        time: DateTime.now().subtract(Duration(days: 1, hours: 3)),
        status: true,
      ),
    ],
  ),
  ChatModel(
    id: '4',
    companionsIds: ['5', '0'],
    messages: [
      MessageModel(
        senderId: '5',
        text: 'Can you send me the file?',
        time: DateTime.now().subtract(Duration(hours: 3)),
        status: true,
      ),
      MessageModel(
        senderId: '0',
        text: 'Sure, give me a moment.',
        time: DateTime.now().subtract(Duration(hours: 2, minutes: 45)),
        status: true,
      ),
      MessageModel(
        senderId: '5',
        text: 'Got it, thanks!',
        time: DateTime.now().subtract(Duration(hours: 2, minutes: 30)),
        status: true,
      ),
    ],
  ),
  ChatModel(
    id: '5',
    companionsIds: ['10', '2'],
    messages: [
      MessageModel(
        senderId: '10',
        text: 'Let’s meet tomorrow at 10 am?',
        time: DateTime.now().subtract(Duration(days: 2)),
        status: true,
      ),
      MessageModel(
        senderId: '0',
        text: 'Sounds good! See you then.',
        time: DateTime.now().subtract(Duration(days: 2, hours: 1)),
        status: true,
      ),
    ],
  ),
];
