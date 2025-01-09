import 'package:flutter/material.dart';

import '../../../../theme.dart';

class GroupChatSettings extends StatefulWidget {
  const GroupChatSettings({super.key});

  @override
  State<GroupChatSettings> createState() => _GroupChatSettingsState();
}

class _GroupChatSettingsState extends State<GroupChatSettings> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height - 100,
      width: screenSize.width,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(

      ),
    );
  }
}
