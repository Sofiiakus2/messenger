import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:messanger/theme.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
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
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26,)
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                      ),
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage('https://wallart.ua/wpmd/5986-orig.jpg'),
                        backgroundColor: Colors.grey[200],
                      ),
                    ],
                  ),
                  Text('Sofiia Kushnirenko',
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                ],
              ),
              SizedBox(height: 20,),
              ListTile(
                leading: const Icon(Icons.account_box_rounded, color: Colors.white, size: 36,),
                title: Text('Аккаунт',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/account');

                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white, size: 36,),
                title: Text('Налаштування',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.help, color: Colors.white, size: 36,),
                title: Text('Допомога',
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
                leading: const Icon(Icons.logout_rounded, color: Colors.white, size: 32,),
                title: Text('Вийти',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
                onTap: () {},
              ),
              Container(height: 20,)
            ],
          ),
        ),
      ),
    );

  }
}
