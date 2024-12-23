import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/repositories/user_repository.dart';
import 'package:messanger/theme.dart';

import '../models/user_model.dart';
import '../repositories/auth_local_storage.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<UserModel?>(
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
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Drawer(
            backgroundColor: primaryColor,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                            ),
                            CircleAvatar(
                              radius: 36,
                            //  backgroundImage: NetworkImage(user.image),
                              backgroundColor: Colors.grey[200],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.account_box_rounded, color: Colors.white, size: 36),
                    title: Text(
                      'Аккаунт',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.toNamed('/account');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.white, size: 36),
                    title: Text(
                      'Налаштування',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.help, color: Colors.white, size: 36),
                    title: Text(
                      'Допомога',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: const Divider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Expanded(child: Container()),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.white, size: 32),
                    title: Text(
                      'Вийти',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    onTap: () async {
                      await AuthLocalStorage().clearUser();
                      Get.toNamed('/login');
                    },
                  ),
                  Container(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
