import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/account/personal_account.dart';
import 'package:messanger/all_chats/chatsPage.dart';
import 'package:messanger/enter/login_page.dart';
import 'package:messanger/enter/sign_up_page.dart';
import 'package:messanger/personal_chat/extraWidgets/chat_details/chat_details_view.dart';
import 'package:messanger/personal_chat/personal_chat_page.dart';
import 'package:messanger/splash_screen.dart';
import 'package:messanger/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBW6OdXoLF0-HazlxcuttxO36XOyGw7_Mc',
          appId: '1:721694459000:android:f4ad5752652b7f5068998d',
          messagingSenderId: '721694459000',
          projectId: 'messanger-3869a'
      )
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: '/splashScreen',
      getPages: [
        GetPage(name: '/', page: () => const ChatsPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signUp', page: () => const SignUpPage()),
        GetPage(name: '/chat', page: () => const PersonalChatPage()),
        GetPage(name: '/account', page: () => const PersonalAccount()),
        GetPage(name: '/splashScreen', page: () => const SplashScreen()),
        GetPage(name: '/chatDetails', page: ()=> const ChatDetailsView()),
      ],
    );
  }
}

