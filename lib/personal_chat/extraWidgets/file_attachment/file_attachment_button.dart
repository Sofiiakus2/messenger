import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messanger/personal_chat/extraWidgets/file_attachment/media_bottom_sheet.dart';
import 'package:messanger/theme.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../models/message_model.dart';

class FileAttachmentButton extends StatefulWidget {
  final Function(MessageModel file) onFileSelected;

  const FileAttachmentButton({super.key, required this.onFileSelected});

  @override
  State<FileAttachmentButton> createState() => _FileAttachmentButtonState();
}

class _FileAttachmentButtonState extends State<FileAttachmentButton> {

  MessageType getFileType(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();

    if (['jpg', 'jpeg', 'png', 'gif', 'bmp'].contains(extension)) {
      return MessageType.photo;
    } else if (['mp4', 'avi', 'mkv', 'mov'].contains(extension)) {
      return MessageType.video;
    } else if (['pdf'].contains(extension)) {
      return MessageType.document;
    } else if (['docx', 'doc'].contains(extension)) {
      return MessageType.document;
    } else if (['rar', 'zip', 'tar', '7z'].contains(extension)) {
      return MessageType.archive;
    } else if (['txt'].contains(extension)) {
      return MessageType.text;
    } else {
      return MessageType.file;
    }
  }


  void _showBottomSheet(BuildContext context) {

    showModalBottomSheet(
      context: context,
      backgroundColor: primaryColor,
      builder: (BuildContext context) {
        return MediaBottomSheet(
          onSelect: (file){
            createFileMessage(file);
          },
        );
      },
    );
  }



  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        createFileMessage(file);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Файл успішно обрано: ${result.files.first.name}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Вибір файлу скасовано')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка під час вибору файлу: $e')),
      );
    }
  }

  void createFileMessage(PlatformFile file){
    MessageModel newFileMessage = MessageModel(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        text: '',
        time: DateTime.now(),
        status: false,
        isEdited: false,
        fileName: file.name,
        filePath: file.path,
        messageType: getFileType(file.path!),
        fileSize: file.size
    );
    widget.onFileSelected(newFileMessage);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showBottomSheet(context),
      icon: const Icon(Icons.photo_camera_back, color: Colors.blue),
    );
  }
}
