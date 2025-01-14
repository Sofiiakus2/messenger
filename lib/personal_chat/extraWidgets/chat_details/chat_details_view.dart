import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/users_list_view.dart';
import 'package:messanger/personal_chat/extraWidgets/custom_app_bar.dart';
import 'package:messanger/repositories/auth_local_storage.dart';
import 'package:messanger/repositories/user_repository.dart';
import 'package:messanger/theme.dart';

import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import 'extraWidgets/add_new_member_button.dart';
import 'extraWidgets/chat_settings_actions/chat_details_actions_view.dart';

class ChatDetailsView extends StatefulWidget {
  const ChatDetailsView({super.key});

  @override
  State<ChatDetailsView> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView> {
 ChatModel? chat;
 UserModel? companion;
 List<UserModel> usersGroupList = [];
 String? currentUserId ;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final arguments = Get.arguments;
      chat = arguments['chat'];

      if (chat!.isGroup == false) {
        companion = await UserModel.getChatCompanion(chat!);
      }
      if (chat!.companionsIds != null) {
        usersGroupList = await UserRepository().getUsersByIds(chat!.companionsIds!);
      }

      currentUserId = await AuthLocalStorage().getUserId();
      setState(() {});

    } catch (e) {
      print('Error loading data: $e');

    }
  }
 bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(
                showActions: _showActions,
                onShowActionsChanged: (bool value) {
                  setState(() {
                    _showActions = value;
                  });
                },
              ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
              ),
              Text(
                chat!.isGroup == true
                    ? chat!.name.toString()
                    : companion!.name,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 26),
              ),
              SizedBox(height: 30,),
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        color: thirdColor.withOpacity(0.3),
                        child: TabBar(
                          labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue),
                          unselectedLabelStyle: Theme.of(context).textTheme.titleMedium,
                          indicatorColor: Colors.blue,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(text: 'Учасники'),
                            Tab(text: 'Медіа'),
                            Tab(text: 'Файли'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  if(chat!.owner == currentUserId || chat!.addNewMember == true)
                                    AddNewMemberButton(
                                      chat: chat!,
                                      resetUsers: () async {
                                        await _loadData();
                                      },
                                    ),
                                  Expanded(child: UsersListView(users: usersGroupList, enableDeleting: true, chatId: chat!.id,)),
                                ],
                              ),
                            ),
                            Center(child: Text('Медіа')),
                            Center(child: Text('Файли')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          ChatActions(
            chat: chat!,
            showActions: _showActions,
            onShowActionsChanged: (bool value) {
              setState(() {
                _showActions = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

