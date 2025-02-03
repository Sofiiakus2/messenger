import 'package:flutter/material.dart';
import 'package:messanger/models/chat_model.dart';
import 'package:messanger/personal_chat/extraWidgets/chat_details/extraWidgets/chat_settings_actions/deleting_confirmation_dialog.dart';
import 'package:messanger/repositories/user_repository.dart';
import 'package:messanger/theme.dart';


class ChatSettingsActions extends StatefulWidget {
  final ChatModel chat;
  final bool showActions;
  final String companionId;
  final Function(bool) onShowActionsChanged;

  const ChatSettingsActions({
    super.key,
    required this.chat,
    required this.showActions,
    required this.onShowActionsChanged,
    required this.companionId,
  });

  @override
  State<ChatSettingsActions> createState() => _ChatSettingsActionsState();
}

class _ChatSettingsActionsState extends State<ChatSettingsActions> {
  bool isFav = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async{
    isFav = await UserRepository().isContactInFavorites(widget.companionId);
  }

  @override
  Widget build(BuildContext context) {
    return widget.showActions
        ? Positioned(
      top: 90,
      right: 40,
      child: GestureDetector(
        onTap: () {
          widget.onShowActionsChanged(false);
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
                        chatId: widget.chat.id,
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
              if(widget.chat.isGroup == false)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if(isFav){
                          UserRepository().removeContactFromFavorites(widget.chat.companionsIds);
                          setState(() {
                            isFav = false;
                          });
                        }else{
                          UserRepository().addContactToFavorites(widget.chat.companionsIds);
                          setState(() {
                            isFav = true;
                          });
                        }
                        widget.onShowActionsChanged(false);
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
