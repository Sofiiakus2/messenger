import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

enum MessageType { text, file, photo, video }

class MessageModel{
  String? id;
  String senderId;
  String text;
  DateTime time;
  bool status;
  bool isEdited;
  MessageType? messageType;
  String? filePath;
  String? fileName;
  int? fileSize;

  MessageModel? replyMessage;

  MessageModel({
    this.id,
   required this.senderId,
   required this.text,
   required this.time,
   required this.status,
   required this.isEdited,
    this.replyMessage,
    this.messageType,
    this.filePath,
    this.fileName,
    this.fileSize,
});

  factory MessageModel.fromMap(Map<String, dynamic> map, String documentId) {
    return MessageModel(
      id: documentId,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      time: (map['time'] as Timestamp).toDate(),
      status: map['status'] as bool,
      isEdited: map['isEdited'] ?? false,
      replyMessage: map['replyMessage'] != null
          ? MessageModel.fromMap(map['replyMessage'] as Map<String, dynamic>, '')
          : null,
    );
  }



  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'time': Timestamp.fromDate(time),
      'status': status,
      'isEdited': isEdited,
      'replyMessage': replyMessage?.toMap(),
    };
  }

  void updateText(String newText) {
    text = newText;
  }

  void updateStatus(bool newStatus) {
    status = newStatus;
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