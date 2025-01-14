import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/theme.dart';

import '../repositories/auth_local_storage.dart';
import '../repositories/auth_repository.dart';
import 'extraWidgets/auth_widgets.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: screenSize.height * 0.7,
              width: screenSize.width,
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 20,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Вхід',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 40),
                  buildInputField(context, 'Email', emailController, 'yourEmail@gmail.com'),
                  const SizedBox(height: 20),
                  buildInputField(context, 'Password', passwordController, '●●●●●●', isPassword: true),
                  const SizedBox(height: 40),
                  Container(
                    width: screenSize.width,
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: () async{
                          User? user = await AuthRepository().loginUser(emailController.text, passwordController.text);
                          await AuthLocalStorage().saveUserId(user!.uid);
                          Get.toNamed('/');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: Text('Увійти', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),)),
                  ),                  const Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/signUp');
                    },
                    child: Text(
                      'Ще немає акаунту? Зареєструватися!',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
