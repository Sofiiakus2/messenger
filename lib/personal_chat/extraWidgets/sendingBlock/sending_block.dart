import 'package:flutter/material.dart';
import '../../../models/message_model.dart';
import '../../../theme.dart';
import '../file_attachment/file_attachment_button.dart';
import 'editing_block.dart';
import 'reply_forward_block.dart';

class SendingBlock extends StatefulWidget {
  const SendingBlock({
    super.key,
    required this.chatId, required this.isEdit, required this.isReply, this.message, required this.onMessageSent, required this.isForward, required this.onFileSent, required this.onCancelSending,
  });

  final String chatId;
  final bool isEdit;
  final bool isReply;
  final bool isForward;
  final MessageModel? message;
  final Function(String) onMessageSent;
  final Function(MessageModel) onFileSent;
  final Function() onCancelSending;

  @override
  State<SendingBlock> createState() => _SendingBlockState();
}

class _SendingBlockState extends State<SendingBlock> {
  TextEditingController messageController = TextEditingController();
  bool isEmpty = true;
  List<String> attachedFiles = [];

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      widget.onMessageSent(text);
      messageController.clear();
      setState(() {
        isEmpty = true;
      });
    }
  }

  void sendFileMessage(MessageModel filePath) {
    widget.onFileSent(filePath);
  }

  void cancelEditMessage() {
    if (widget.message!.text.isNotEmpty) {
      widget.onMessageSent(widget.message!.text);
      messageController.clear();
      setState(() {
        isEmpty = true;
      });
    }
  }

  void cancelSendingMessage() {
      messageController.clear();
      widget.onCancelSending();

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SendingBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEdit && widget.message != null && widget.message!.text != oldWidget.message?.text) {
      messageController.text = widget.message!.text;
      setState(() {
        isEmpty = widget.message!.text.isEmpty;
      });
    }

    if (widget.isReply && widget.message != null && widget.message!.text != oldWidget.message?.text) {
      setState(() {
        isEmpty = widget.message!.text.isEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isEdit)
          EditingBlock(cancelEditMessage: cancelEditMessage),
        if (widget.isReply || widget.isForward)
          ReplyForwardBlock(
            isReply: widget.isReply,
            isForward: widget.isForward,
            message: widget.message,
            cancelSendingMessage: cancelSendingMessage,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 330,
              constraints: const BoxConstraints(
                minHeight: 60,
                maxHeight: 140,
              ),
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        setState(() {
                          isEmpty = value.isEmpty;
                        });
                      },
                      maxLines: null,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Aa",
                        hintStyle: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      cursorColor: thirdColor,
                      scrollPhysics: const BouncingScrollPhysics(),
                    ),
                  ),
                  FileAttachmentButton(onFileSelected: sendFileMessage),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: IconButton(
                onPressed: sendMessage,
                icon: Icon(
                  isEmpty ? Icons.mic : Icons.send,
                  color: thirdColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
