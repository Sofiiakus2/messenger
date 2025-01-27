import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/all_chats/extraWidgets/searchChatsPage/search_tabbar.dart';

import '../../../controllers/chat_controller.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme.dart';

class SearchChatsView extends StatefulWidget {
  const SearchChatsView({super.key,});


  @override
  State<SearchChatsView> createState() => _SearchChatsViewState();
}

class _SearchChatsViewState extends State<SearchChatsView> {
  final TextEditingController _searchController = TextEditingController();
  final chatController = Get.put(ChatController());
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    allUsers = await UserRepository().getAllUsers();
    filteredUsers = allUsers; // Initially show all users
  }

  void filterUsers(String searchTerm) {
    filteredUsers = allUsers.where((user) => user.name.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10).copyWith(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: screenSize.width/1.2,
                    padding: EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        chatController.filterChats(value);
                        filterUsers(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Пошук',
                        hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.black,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontSize: 20,
                          color: Colors.black
                      ),
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                  IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: fourthColor, size: 30,)),
                ],
              ),
            ),
            SearchTabbar(chatController: chatController, filteredUsers: filteredUsers,),


          ],
        ),
      ),
    );
  }
}