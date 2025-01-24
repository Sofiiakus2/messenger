import 'package:flutter/material.dart';
import 'package:messanger/all_chats/extraWidgets/createChatSheet/create_chat_sheet.dart';
import 'package:messanger/all_chats/extraWidgets/searchChatsPage/search_chats_view.dart';
import 'package:messanger/nav_bar/nav_bar.dart';
import 'package:messanger/theme.dart';

import 'extraWidgets/all_chats.dart';
import 'extraWidgets/favourite_contacts.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return CreateChatSheet();
              },
            );
          },
        backgroundColor: primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.edit_outlined,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(10).copyWith(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.menu, color: fourthColor, size: 30),
                      );
                    },
                  ),

                  IconButton(
                      onPressed: (){
                        Navigator.of(context).push(_createRoute());
                      },
                      icon: const Icon(Icons.search, color: fourthColor, size: 30,)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20, bottom: 30),
              child: Text('Повідомлення', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),),
            ),
            const Stack(
              children: [
                FavouriteContacts(),
                AllChats()
              ],
            )
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const SearchChatsView(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

