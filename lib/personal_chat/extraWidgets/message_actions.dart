import 'dart:math';

import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

import '../../models/message_model.dart';

class MessageActions extends StatelessWidget {
  final String? currentUserId;
  final int selectedMessageIndex;
  final List<MessageModel> messages;
  final Offset tapPosition;
  final Function(String) deleteMessage;
  final Function() editMessage;
  final Function() replyMessage;
  final Function() hideActions;
  final Function() copyAction;

  const MessageActions({
    required this.currentUserId,
    required this.selectedMessageIndex,
    required this.messages,
    required this.tapPosition,
    required this.deleteMessage,
    required this.editMessage,
    required this.replyMessage,
    required this.hideActions,
    required this.copyAction,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: tapPosition.dy,
      left: tapPosition.dx,
      child: GestureDetector(
        onTap: hideActions,
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 5,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (messages[selectedMessageIndex].senderId == currentUserId)
                GestureDetector(
                  onTap: (){
                    editMessage();
                    hideActions();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Редагувати",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
                      ),
                      Icon(Icons.edit, color: Colors.black),
                    ],
                  ),
                ),
              if (messages[selectedMessageIndex].senderId == currentUserId)
                Container(
                  width: 170,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Divider(
                  ),
                ),
              GestureDetector(
                onTap: () {
                  replyMessage();
                  hideActions();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Відповісти",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
                    ),
                    Icon(Icons.reply_sharp, color: Colors.black),

                  ],
                ),
              ),
              Container(
                width: 170,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                ),
              ),
              GestureDetector(
                onTap: () {
                  copyAction();
                  hideActions();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Текст скопійовано у буфер обміну',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                      duration: const Duration(seconds: 2),
                      backgroundColor: thirdColor.withOpacity(0.5),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.only(bottom: 50, left: 10, right: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Копіювати",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
                    ),
                    Icon(Icons.file_copy_rounded, color: Colors.black),

                  ],
                ),
              ),
              Container(
                width: 170,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Handle forward
                  hideActions();
                  // Add your forward message logic here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Переслати",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 18),
                    ),
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: Icon(Icons.reply_sharp, color: Colors.black),
                    ),

                  ],
                ),
              ),
              Container(
                width: 170,
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Divider(
                ),
              ),
              GestureDetector(
                onTap: () {
                  deleteMessage(messages[selectedMessageIndex].id!);
                  hideActions();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Видалити",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 18,
                        color: Color(0xFF8C0809),
                      ),
                    ),
                    Icon(Icons.delete, color: Color(0xFF8C0809)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
