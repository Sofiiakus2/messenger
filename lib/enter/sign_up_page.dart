import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/auth_repository.dart';
import '../theme.dart';

import 'extraWidgets/auth_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? passwordError;
  bool isLoginMethodEmail = false;
  String? validationMessage;
  bool isLoading = false;

  void validatePassword() {
    setState(() {
      if (passwordController.text.length < 6) {
        passwordError = 'Пароль повинен містити щонайменше 6 символів';
      } else {
        passwordError = null;
      }
    });
  }

  void validateInput() {
    if (isLoginMethodEmail) {
      // Перевірка на коректність пошти
      final emailRegex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      if (!emailRegex.hasMatch(loginController.text)) {
        validationMessage = 'Введіть коректну електронну пошту';
      } else {
        validationMessage = null;
      }
    } else {
      // Перевірка на коректність номера телефону (в форматі +380987654321)
      final phoneRegex = RegExp(r"^\+380\d{9}$");
      if (!phoneRegex.hasMatch(loginController.text)) {
        validationMessage = 'Номер телефону має бути у форматі: +380987654321';
      } else {
        validationMessage = null;
      }
    }
  }

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
                  buildInputField(context, 'Ім\'я', nameController, 'Іван', showToggle: false),
                  const SizedBox(height: 20),
                  buildInputField(
                      context, 'Телефон',
                      loginController,
                      'Логін',
                      showToggle: true,
                      onChanged: (_) => validateInput(),
                      onMethodChanged: (value){
                        setState(() {
                          isLoginMethodEmail = value;
                        });
                        validateInput();
                      }
                  ),
                  if (validationMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        validationMessage!,
                        style: TextStyle(color: thirdColor, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if(isLoginMethodEmail)
                  buildInputField(
                    context,
                    'Пароль',
                    passwordController,
                    '●●●●●●',
                    isPassword: true,
                    showToggle: false,
                    onChanged: (_) => validatePassword(),
                  ),
                  if (passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        passwordError!,
                        style: TextStyle(color: thirdColor, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  const SizedBox(height: 40),

                  buildRegisterButton(
                      context,
                      nameController,
                      loginController,
                      passwordController,
                      isLoginMethodEmail
                  ),
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
