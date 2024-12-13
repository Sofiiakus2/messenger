import 'package:flutter/material.dart';

import '../../theme.dart';

class SendingBlock extends StatefulWidget {
  const SendingBlock({
    super.key,
    required this.chatId,
    required this.isEdit,
    this.text,
    required this.onMessageSent,
  });

  final String chatId;
  final bool isEdit;
  final String? text;
  final Function(String) onMessageSent;

  @override
  State<SendingBlock> createState() => _SendingBlockState();
}

class _SendingBlockState extends State<SendingBlock> {
  TextEditingController messageController = TextEditingController();
  bool isEmpty = true;

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SendingBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEdit && widget.text != null && widget.text != oldWidget.text) {
      messageController.text = widget.text!;
      setState(() {
        isEmpty = widget.text!.isEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.isEdit)
       Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.only(left: 20),
            decoration: const BoxDecoration(
              color: thirdColor,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Text(
              'Редагування',
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.white),
            ),
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
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.copyWith(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Aa",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      cursorColor: thirdColor,
                      scrollPhysics: const BouncingScrollPhysics(), // Додатково для плавного скролу
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.photo_camera_back, color: thirdColor),
                  ),
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
