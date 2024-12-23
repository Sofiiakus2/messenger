import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:intl/intl.dart';

enum MessageType { text, file, photo, video, archive, document }

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
      messageType: map['messageType'] != null
          ? MessageType.values.firstWhere(
              (e) => e.toString() == 'MessageType.' + map['messageType'])
          : null,
      filePath: map['filePath'] as String?,
      fileName: map['fileName'] as String?,
      fileSize: map['fileSize'] as int?,
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
      'messageType': messageType?.toString().split('.').last, // збереження типу повідомлення
      'filePath': filePath,
      'fileName': fileName,
      'fileSize': fileSize,
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
    // Формат HH:mm
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  } else if (diff.inDays <= 7) {
    // Назва дня тижня
    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek[time.weekday - 1];
  } else if (time.year == now.year) {
    // Формат dd.MM
    return '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}';
  } else {
    // Формат dd.MM.yyyy
    return '${time.day.toString().padLeft(2, '0')}.${time.month.toString().padLeft(2, '0')}.${time.year}';
  }
}
