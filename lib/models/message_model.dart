import 'package:intl/intl.dart';

import 'chat_model.dart';

class MessageModel{
  String senderId;
  String text;
  DateTime time;
  bool status;

  MessageModel({
   required this.senderId,
   required this.text,
   required this.time,
   required this.status
});

  void updateText(String newText) {
    text = newText;
  }

  void updateStatus(bool newStatus) {
    status = newStatus;
  }

  static List<MessageModel> getMessagesByChatId(String chatId) {
    final chat = chats.firstWhere((chat) => chat.id == chatId);

    return chat.messages;
  }

}

String formatLastMessageTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final diff = now.difference(time);

  if (time.isAfter(today)) {
    return DateFormat('HH:mm').format(time);
  } else if (diff.inDays <= 7) {
    return DateFormat('EEE').format(time);
  } else if (time.year == now.year) {
    return DateFormat('dd.MM').format(time);
  } else {
    return DateFormat('dd.MM.yyyy').format(time);
  }
}