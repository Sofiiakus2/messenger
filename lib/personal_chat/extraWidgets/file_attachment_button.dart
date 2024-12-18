import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/message_model.dart';

class FileAttachmentButton extends StatelessWidget {
  final Function(MessageModel file) onFileSelected;

  const FileAttachmentButton({Key? key, required this.onFileSelected}) : super(key: key);

  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        MessageModel newFileMessage = MessageModel(
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: '',
            time: DateTime.now(),
            status: false,
            isEdited: false,
            fileName: file.name,
            filePath: file.path,
          messageType: MessageType.file,
          fileSize: file.size
        );
        onFileSelected(newFileMessage);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл успішно обрано: ${result.files.first.name}'),
          ),
        );
      } else {
        // Користувач скасував вибір
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вибір файлу скасовано')),
        );
      }
    } catch (e) {
      // Обробка помилок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка під час вибору файлу: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _pickFile(context),
      icon: const Icon(Icons.photo_camera_back, color: Colors.blue),
    );
  }
}
