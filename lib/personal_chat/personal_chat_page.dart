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
import 'extraWidgets/message_actions.dart';
import 'extraWidgets/message_list.dart';
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
  Offset? _tapPosition;
  bool isEdit = false;
  bool isReply = false;

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
      messages = chat!.messages!;
    });
  }

  void _toggleEdit(bool editState) {
    setState(() {
      isReply = false;
      isEdit = editState;
    });
  }

  void _toggleReply(bool replyState) {
    setState(() {
      isEdit = false;
      isReply = replyState;
    });
  }


  void _onLongPress(int index, LongPressStartDetails details) {
    setState(() {
      _showActions = true;
      _selectedMessageIndex = index;
      _tapPosition = details.globalPosition;
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

  void _saveReplyMessage(MessageModel replyMessage, String newText) async{
    if (currentUserId == null || companion == null) return;

    final newMessage = MessageModel(
        senderId: currentUserId!,
        text: newText,
        time: DateTime.now(),
        status: false,
        isEdited: false,
        replyMessage: replyMessage
    );

    setState(() {
      messages.insert(0, newMessage);
    });

    scrollChat();

    try {
      await MessagesRepository().sendMessage(chat!.id, newMessage);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _saveEditedMessage(String messageId, String newText) async {

      setState(() {
        messages[_selectedMessageIndex].text = newText!;
      });
      try {
        await MessagesRepository().updateMessage(chatId!,messageId, newText);
      } catch (e) {
        print('Error updating message: $e');
      }

      setState(() {
        _selectedMessageIndex = -1;
      });

  }


  void addMessage(String text) async {
    if (currentUserId == null || companion == null) return;

    final newMessage = MessageModel(
      senderId: currentUserId!,
      text: text,
      time: DateTime.now(),
      status: false,
      isEdited: false
    );

    setState(() {
      messages.insert(0, newMessage);
    });

    scrollChat();

    try {
      await MessagesRepository().sendMessage(chat!.id, newMessage);
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void scrollChat() {
    Future.delayed(Duration(milliseconds: 100), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });
    });
  }

  void _hideMessageActions() {
    setState(() {
      _showActions = false;
     // _selectedMessageIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: _hideMessageActions,
            child: const SizedBox(width: double.infinity, height: double.infinity),
          ),
          const CustomAppBar(),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: _hideMessageActions,
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
                      child: MessageList(
                        scrollController: _scrollController,
                        messages: messages,
                        currentUserId: currentUserId,
                        companion: companion,
                        onLongPressStart: _onLongPress,
                      ),
                    ),
                    const SizedBox(height: 15,),
                    SendingBlock(
                      chatId: '',
                      isEdit: isEdit,
                      isReply: isReply,
                      text: isEdit || isReply ? messages[_selectedMessageIndex].text : null,
                      onMessageSent: (text) {
                        if (isEdit) {
                          _saveEditedMessage(messages[_selectedMessageIndex].id!, text);
                        } else if(isReply){
                          _saveReplyMessage(messages[_selectedMessageIndex], text);
                        }
                        else {
                          addMessage(text);
                        }
                        _toggleEdit(false);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showActions && _selectedMessageIndex != -1)
            MessageActions(
              currentUserId: currentUserId!,
              selectedMessageIndex: _selectedMessageIndex,
              messages: messages,
              tapPosition: _tapPosition!,
              deleteMessage: deleteMessage,
              editMessage: () => _toggleEdit(true),
              replyMessage: () => _toggleReply(true),
              hideActions: _hideMessageActions,
            ),
        ],
      ),
    );
  }
}
