import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/models/message_model.dart';
import 'package:messanger/repositories/auth_local_storage.dart';
import 'package:messanger/repositories/messages_repository.dart';
import 'package:messanger/theme.dart';
import '../models/chat_model.dart';
import '../models/user_model.dart';
import '../repositories/chat_repository.dart';
import 'extraWidgets/custom_app_bar.dart';
import 'extraWidgets/message_view.dart';
import 'extraWidgets/sending_block.dart';

class PersonalChatPage extends StatefulWidget {
  const PersonalChatPage({super.key});

  @override
  State<PersonalChatPage> createState() => _PersonalChatPageState();
}

class _PersonalChatPageState extends State<PersonalChatPage> {
  final ScrollController _scrollController = ScrollController();

  List<MessageModel> messages = [];
  ChatModel? chat;
  String? chatId;
  UserModel? companion;
  String? currentUserId;
  bool _showActions = false;
  int _selectedMessageIndex = -1;
  Offset? _tapPosition ;


  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    currentUserId = await AuthLocalStorage().getUserId();

    final arguments = Get.arguments;
    chatId = arguments['chatId'];
    chat = await ChatRepository().getChatById(chatId!);

    UserModel.getChatCompanion(chat!).then((companionUser) {
      setState(() {
        companion = companionUser;
      });
    });

    setState(() {
      messages = chat!.messages;
    });
    //Todo: change the wrong message position

    scrollChat();
  }

  void _onLongPress(Offset position, int index) {
    setState(() {
      _showActions = true;
      _selectedMessageIndex = index;
      _tapPosition = position;
    });
  }

  void deleteMessage(String messageId) async {
    try {
      if (chatId == null) return;

      setState(() {
        messages.removeWhere((message) => message.id == messageId);
      });

      await MessagesRepository().deleteMessage(chatId!, messageId);
    } catch (e) {
      print('Error deleting message: $e');
    }
  }

  void addMessage(String text) async {
    if (currentUserId == null || companion == null) return;

    final newMessage = MessageModel(
      senderId: currentUserId!,
      text: text,
      time: DateTime.now(),
      status: false,
    );

    setState(() {
      messages.add(newMessage);
    });

    scrollChat();

    try {
      await MessagesRepository().sendMessage(chat!.id, newMessage);
    } catch (e) {
      print('Error sending message: $e');
    }

  }

  void scrollChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  void _hideMessageActions() {
    setState(() {
      _showActions = false;
      _selectedMessageIndex = -1;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              _hideMessageActions();
            },
            child: Container(
              color: Colors.transparent, // Робимо його прозорим, щоб він реагував на натискання
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          const CustomAppBar(),
          Positioned(
            bottom: 0,
            child: Container(
              width: screenSize.width,
              height: screenSize.height * 0.88,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: companion == null
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      companion!.name,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Text(
                    'Online',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      height: screenSize.height * 0.65,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: messages.isEmpty
                          ? Center(
                        child: Text(
                          'У вас ще немає повідомлень',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      )
                          : ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          bool isSenderMe =
                              messages[index].senderId == currentUserId;
                          return GestureDetector(
                            onLongPressStart: (LongPressStartDetails details) {
                              _onLongPress(details.globalPosition, index);

                            },
                            child: MessageView(
                              isSenderMe: isSenderMe,
                              companion: companion,
                              messages: messages,
                              index: index,
                              status: messages[index].status,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SendingBlock(
                    chatId: '',
                    onMessageSent: (text) {
                      addMessage(text);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_showActions && _selectedMessageIndex != -1)

            Positioned(
              top: _tapPosition!.dy,
              left: _tapPosition!.dx,
              child: GestureDetector(
                onTap: _hideMessageActions,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _hideMessageActions();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              "Edit",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          deleteMessage(messages[_selectedMessageIndex].id!);
                          _hideMessageActions();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              "Delete",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle forward
                          _hideMessageActions();
                          // Add your forward message logic here
                        },
                        child: Row(
                          children: [
                            Icon(Icons.forward, color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              "Forward",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
