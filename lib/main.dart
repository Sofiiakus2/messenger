import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:messanger/account/personal_account.dart';
import 'package:messanger/all_chats/chatsPage.dart';
import 'package:messanger/personal_chat/personal_chat_page.dart';
import 'package:messanger/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => ChatsPage()),
        GetPage(name: '/chat', page: () => PersonalChatPage()),
        GetPage(name: '/account', page: () => PersonalAccount())
      ],
    );
  }
}

