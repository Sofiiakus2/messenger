import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_model.dart';
import '../../theme.dart';

class CustomAppBar extends StatelessWidget {
  final bool showActions;
  final Function(bool) onShowActionsChanged;


  const CustomAppBar({
    super.key,
    required this.showActions,
    required this.onShowActionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_rounded, color: fourthColor, size: 30),
          ),
          IconButton(
            onPressed: () {
              onShowActionsChanged(!showActions);
            },
            icon: const Icon(Icons.more_vert, color: fourthColor, size: 30),
          ),
        ],
      ),
    );
  }
}
