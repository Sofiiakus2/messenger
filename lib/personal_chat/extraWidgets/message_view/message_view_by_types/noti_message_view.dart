import 'package:flutter/material.dart';
import 'package:messanger/models/message_model.dart';

import '../../../../theme.dart';


class NotiMessageView extends StatelessWidget {
  const NotiMessageView({super.key, required this.noti});
  final MessageModel noti;


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
              color: thirdColor.withOpacity(0.3),
              borderRadius: BorderRadius.all(
                const Radius.circular(30),
              ),
            ),
            child: Text(noti.text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.black, fontSize: 18),),
          ),
        )
      ],
    );
  }
}
