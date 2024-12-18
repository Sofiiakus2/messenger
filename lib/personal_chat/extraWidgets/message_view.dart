import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messanger/personal_chat/extraWidgets/reply_message_view.dart';

import '../../models/message_model.dart';
import '../../models/user_model.dart';
import '../../theme.dart';

class MessageView extends StatelessWidget {
  const MessageView({
    super.key,
    required this.isSenderMe,
    required this.companion,
    required this.messages,
    required this.index,
    required this.status,
  });

  final bool isSenderMe;
  final UserModel? companion;
  final List<MessageModel> messages;
  final int index;
  final bool status;

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

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!isSenderMe)
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey[200],
            ),
          if (isSenderMe)
            Row(
              children: [
                status
                    ? SvgPicture.asset(
                  'assets/double-check.svg',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                )
                    : const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
                Text(
                  formatLastMessageTime(messages[index].time),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          Container(
            width: 270,
            padding: const EdgeInsets.only(left: 20, top: 10),
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(30),
                topLeft: const Radius.circular(30),
                bottomLeft: isSenderMe
                    ? const Radius.circular(30)
                    : const Radius.circular(0),
                bottomRight: isSenderMe
                    ? const Radius.circular(0)
                    : const Radius.circular(30),
              ),
            ),
            child: messages[index].messageType == MessageType.file
              ? Container(
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
                            messages[index].fileName!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: thirdColor, fontSize: 14),
                          ),
                          Text(
                            formatFileSize(messages[index].fileSize!),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: primaryColor, fontSize: 14),
                          ),
                        ],
                      )
                    ],
                  ),
            )
              : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(messages[index].replyMessage != null)
                  ReplyMessageView(message: messages[index].replyMessage!,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    messages[index].text,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.black),
                  ),
                ),
                if(messages[index].isEdited)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Text(
                      'Змінено',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isSenderMe)
            CircleAvatar(
              radius: 24,
              backgroundImage: const NetworkImage('https://wallart.ua/wpmd/5986-orig.jpg'),
              backgroundColor: Colors.grey[200],
            ),
          if (!isSenderMe)
            Row(
              children: [
                status
                    ? SvgPicture.asset(
                  'assets/double-check.svg',
                  width: 16,
                  height: 16,
                  color: Colors.white,
                )
                    : const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
                Text(
                  formatLastMessageTime(messages[index].time),
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
