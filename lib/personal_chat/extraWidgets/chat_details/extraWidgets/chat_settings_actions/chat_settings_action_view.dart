import 'package:flutter/material.dart';
import 'package:messanger/models/chat_model.dart';
import 'package:messanger/personal_chat/extraWidgets/chat_details/extraWidgets/chat_settings_actions/deleting_confirmation_dialog.dart';
import 'package:messanger/repositories/user_repository.dart';
import 'package:messanger/theme.dart';


class ChatSettingsActions extends StatelessWidget {
  final ChatModel chat;
  final bool showActions;
  final Function(bool) onShowActionsChanged;

  const ChatSettingsActions({
    super.key,
    required this.chat,
    required this.showActions,
    required this.onShowActionsChanged,
  });

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
            color: thirdColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeletingConfirmationDialog(
                        chatId: chat.id,
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Видалити чат",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if(chat.isGroup == false)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        UserRepository().addContactToFavorites(chat.companionsIds);
                        onShowActionsChanged(false);
                        },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "До улюблених",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
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
