import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

import '../all_chats/extraWidgets/searchChatsPage/search_chats_view.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class PersonalAccount extends StatefulWidget {
  const PersonalAccount({super.key});

  @override
  State<PersonalAccount> createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: StreamBuilder<UserModel?>(
          stream: UserRepository().getUserInfo(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Помилка: ${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('Користувача не знайдено'));
            }

            final user = snapshot.data!;
          return SizedBox(
            height: screenSize.height,
            width: screenSize.width,
            child: Stack(
              children: [
                Image.network(
                  'https://wallart.ua/wpmd/5986-orig.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: screenSize.height * 0.6,
                ),

                Positioned(
                  bottom: 0,
                  child: Container(
                    height: screenSize.height * 0.5,
                    width: screenSize.width,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          Text(
                            user.name,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 40,
                                color: Colors.white
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 5),
                          user.description != null && user.description!.isNotEmpty
                              ? Text(
                            user.description!,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 24),
                          )
                              : const SizedBox.shrink(),

                          const SizedBox(height: 20,),
                          if(user.email != null)
                            Text(
                              user.email!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontSize: 20, color: secondaryColor, decoration: TextDecoration.underline ),
                            ),
                          if(user.phone != null)
                            Text(
                              user.phone!,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(fontSize: 20, color: secondaryColor, decoration: TextDecoration.underline ),
                            ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(_createRoute());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Мої контакти',
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const Icon(Icons.navigate_next_outlined)
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),

              ],
            ),
          );
        }
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