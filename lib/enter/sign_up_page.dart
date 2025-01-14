import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';

import 'extraWidgets/auth_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const SizedBox.expand(),
          SizedBox(
            height: screenSize.height * 0.3,
            child: Center(
              child: Text(
                'Реєстрація',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
              ),
            ),
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
                  const SizedBox(height: 40),
                  buildInputField(context, 'Ім\'я', nameController, 'Іван'),
                  const SizedBox(height: 20),
                  buildInputField(context, 'Email', emailController, 'yourEmail@gmail.com'),
                  const SizedBox(height: 20),
                  buildInputField(context, 'Пароль', passwordController, '●●●●●●', isPassword: true),
                  const SizedBox(height: 40),
                  buildRegisterButton(context, nameController, emailController, passwordController),
                  const Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: Text(
                      'Вже є акаунт? Увійти!',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
