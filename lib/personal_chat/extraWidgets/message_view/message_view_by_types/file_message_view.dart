import 'package:flutter/material.dart';
import 'package:messanger/models/message_model.dart';

import '../../../../theme.dart';


class FileMessageView extends StatelessWidget {
  const FileMessageView({super.key, required this.file});
  final MessageModel file;

  String formatFileSize(int sizeInBytes) {
    double sizeInMB = sizeInBytes / (1024 * 1024);
    double sizeInGB = sizeInBytes / (1024 * 1024 * 1024);

    if (sizeInGB >= 1) {
      return "${sizeInGB.toStringAsFixed(2)} GB";
    } else {
      return "${sizeInMB.toStringAsFixed(2)} MB";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.file_present_rounded,
            size: 44,
            color: thirdColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                file.fileName!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: thirdColor, fontSize: 14),
              ),
              Text(
                formatFileSize(file.fileSize!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryColor, fontSize: 14),
              ),
            ],
          )
        ],
      ),
    );
  }
}
