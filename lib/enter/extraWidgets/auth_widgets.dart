import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../repositories/auth_repository.dart';
import '../../theme.dart';


Widget buildInputField(BuildContext context, String label, TextEditingController controller, String hintText, {bool isPassword = false}) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: Theme.of(context).textTheme.bodySmall,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ],
    ),
  );
}

Widget buildRegisterButton(BuildContext context, TextEditingController nameController, TextEditingController emailController, TextEditingController passwordController) {
  return Container(
    width: double.infinity,
    height: 80,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(
      onPressed: () {
        AuthRepository().registerUser(emailController.text, passwordController.text, nameController.text);        emailController.clear();
        passwordController.clear();
        nameController.clear();
        Get.toNamed('/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Text(
        'Зареєструватися',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
