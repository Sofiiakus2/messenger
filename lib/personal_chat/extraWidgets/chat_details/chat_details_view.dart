import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:googleapis/playcustomapp/v1.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/users_list_view.dart';
import 'package:messanger/personal_chat/extraWidgets/custom_app_bar.dart';
import 'package:messanger/repositories/user_repository.dart';
import 'package:messanger/theme.dart';

import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/chat_repository.dart';
import 'chat_settings/group_chat_settings.dart';

class ChatDetailsView extends StatefulWidget {
  const ChatDetailsView({super.key});

  @override
  State<ChatDetailsView> createState() => _ChatDetailsViewState();
}

class _ChatDetailsViewState extends State<ChatDetailsView> {
 ChatModel? chat;
 UserModel? companion;
 List<UserModel> usersGroupList = [];

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

      setState(() {

      });

    } catch (e) {
      print('Error loading data: $e');

    }
  }
 bool _showActions = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
                            //Center(child: Text('Учасники')),
                            SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: UsersListView(users: usersGroupList),
                            ),
                            //UsersListView(users: usersGroupList),
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
          if (_showActions)
            Positioned(
                top: 90,
                right: 40,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showActions = false;
                    });
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
                          onTap: () {
                            setState(() {
                              _showActions = false;
                            });
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return GroupChatSettings();
                              },
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.edit, color: Colors.white, size: 24,),
                              const SizedBox(width: 10),
                              Text("Налаштування", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
            )
        ],
      ),
    );
  }
}
