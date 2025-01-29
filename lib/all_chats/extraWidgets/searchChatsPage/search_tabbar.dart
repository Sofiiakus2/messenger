import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

import '../../../models/user_model.dart';
import '../chats_block_view.dart';
import '../createChatSheet/users_list_view.dart';

class SearchTabbar extends StatefulWidget {
  const SearchTabbar({super.key, this.chatController, required this.filteredUsers});
  final chatController;
  final  List<UserModel> filteredUsers;

  @override
  State<SearchTabbar> createState() => _SearchTabbarState();
}

class _SearchTabbarState extends State<SearchTabbar> with SingleTickerProviderStateMixin{
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: thirdColor,
          labelColor: thirdColor,
          unselectedLabelColor: secondaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Чати'),
            Tab(text: 'Контакти'),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TabBarView(
            controller: _tabController,
            children: [
              ChatsBlockView(
                chatController: widget.chatController,
                chats: widget.chatController.filteredChats,
                isMessageNeed: false,
              ),
              UsersListView(
                users: widget.filteredUsers,
                enableDeleting: false,)

            ],
          ),
        ),
      ],
    );
  }
}
