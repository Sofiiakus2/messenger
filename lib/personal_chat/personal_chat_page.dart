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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    currentUserId = await AuthLocalStorage().getUserId();

    final arguments = Get.arguments;
    chatId = arguments['chatId'] ;
    chat = await ChatRepository().getChatById(chatId!);
    // print('-------------------');
    // print(chat!.messages);

    UserModel.getChatCompanion(chat!).then((companionUser) {
      setState(() {
        companion = companionUser;
      });
    });

    setState(() {
      messages = List.from(chat!.messages);
    });
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
      messages.insert(0, newMessage);
    });

    try {
      await MessagesRepository().sendMessage(chat!.id, newMessage);
    } catch (e) {
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
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
          SizedBox(
            height: screenSize.height,
            width: screenSize.width,
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
                      child:
                          messages.isEmpty
                      ? Center(child: Text('У вас ще немає повідомлень', style: Theme.of(context).textTheme.labelSmall,))
                      : ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          bool isSenderMe = messages[index].senderId == currentUserId;
                          return MessageView(
                            isSenderMe: isSenderMe,
                            companion: companion,
                            messages: messages,
                            index: index,
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
        ],
      ),
    );
  }
}
