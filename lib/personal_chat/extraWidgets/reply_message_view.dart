import 'package:flutter/material.dart';
import 'package:messanger/models/message_model.dart';
import 'package:messanger/models/user_model.dart';
import 'package:messanger/repositories/user_repository.dart';

import '../../theme.dart';

class ReplyMessageView extends StatefulWidget {
  const ReplyMessageView({super.key, required this.message});

  final MessageModel message;

  @override
  State<ReplyMessageView> createState() => _ReplyMessageViewState();
}

class _ReplyMessageViewState extends State<ReplyMessageView> {
  late UserModel? replyUser;

  @override
  void initState() {
    super.initState();
    _loadReplyUser();
  }

  Future<void> _loadReplyUser() async {
    replyUser = await UserRepository().getUser(widget.message.senderId);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      margin: EdgeInsets.only(right: 20, bottom: 5),
      padding: EdgeInsets.only(left: 5, bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: thirdColor.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(10),),
        border: const Border(
          left: BorderSide(
            color: thirdColor,
            width: 5,
          ),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              replyUser == null
                ? 'Відповідь'
                : replyUser!.name,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: thirdColor),),
            Text(
              widget.message.text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800),),
          ],
        ),
      ),

    );
  }
}