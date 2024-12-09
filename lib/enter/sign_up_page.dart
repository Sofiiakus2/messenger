import 'package:flutter/material.dart';
import 'package:messanger/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../theme.dart';

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
          const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          SizedBox(
            height: screenSize.height * 0.3,
            child:  Center(
              child: Text('Реєстрація',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),),
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
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Ім\'я',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                        ),
                        TextField(
                          controller: nameController,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            hintText: 'Іван',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Email',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                        ),
                        TextField(
                          controller: emailController,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            hintText: 'yourEmail@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Пароль',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                        ),
                        TextField(
                          controller: passwordController,
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            hintText: '●●●●●●',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: const OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: screenSize.width,
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: (){
                          AuthRepository().registerUser(emailController.text, passwordController.text, nameController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Відступи
                        ),
                        child: Text('Зареєструватися', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),)),
                  ),
                  const Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: (){
                      Get.toNamed('/login');
                    },
                    child:  Text(
                        'Вже є акаунт? Увійти!',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                    ),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
