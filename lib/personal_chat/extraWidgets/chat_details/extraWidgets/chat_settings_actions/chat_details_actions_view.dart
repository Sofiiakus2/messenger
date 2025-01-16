import 'package:flutter/material.dart';
import 'package:messanger/models/chat_model.dart';
import 'package:messanger/repositories/auth_local_storage.dart';
import 'package:messanger/theme.dart';

import '../../chat_settings/group_chat_settings.dart';

class ChatActions extends StatelessWidget {
  final ChatModel chat;
  final bool showActions;
  final Function(bool) onShowActionsChanged;
  final Function(String) onChatNameUpdated;

  const ChatActions({
    Key? key,
    required this.chat,
    required this.showActions,
    required this.onShowActionsChanged,
    required this.onChatNameUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showActions
        ? Positioned(
      top: 90,
      right: 40,
      child: GestureDetector(
        onTap: () {
          onShowActionsChanged(false);
        },
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: thirdColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  String? currentUserId =
                  await AuthLocalStorage().getUserId();
                  if (chat.owner == currentUserId || chat.editProfileData == true) {
                    onShowActionsChanged(false);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return GroupChatSettings(
                          chat: chat,
                          onChatNameUpdated: onChatNameUpdated,
                        );
                      },
                    ).then((_) {
                      print('Modal bottom sheet closed');

                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Налаштування",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    )
        : const SizedBox();
  }
}
