import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/enter/extraWidgets/code_input_dialog.dart';
import 'package:messanger/enter/extraWidgets/custom_login_toggle.dart';

import '../../repositories/auth_local_storage.dart';
import '../../repositories/auth_repository.dart';
import '../../theme.dart';


Widget buildInputField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String hintText, {
      bool isPassword = false,
      bool isLoginMethodEmail = false,
      required bool showToggle,
      Function(String)? onChanged,
      Function(bool)? onMethodChanged,
    }) {

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
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
            ),
            SizedBox(width: 15,),
            if(showToggle)
            Row(
              children: [
                CustomLoginToggle(
                  initialValue: isLoginMethodEmail,
                  onToggle: (value){
                    isLoginMethodEmail = value;
                    onMethodChanged!(value);
                  },
                ),
                SizedBox(width: 15,),
                Text(
                  'Email',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        TextField(
          controller: controller,
          obscureText: isPassword,
          onChanged: onChanged,
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


Widget buildRegisterButton(BuildContext context, TextEditingController nameController, TextEditingController loginController, TextEditingController passwordController, bool isLoginMethodEmail) {
  return Container(
    width: double.infinity,
    height: 80,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    child: ElevatedButton(

      onPressed: () {
        if(isLoginMethodEmail){
          AuthRepository().registerUserWithEmail(loginController.text, passwordController.text, nameController.text);
          loginController.clear();
          passwordController.clear();
          nameController.clear();
          Get.toNamed('/login');
        }else{
          AuthRepository().sendOtp(
              loginController.text,
                (String verificationId) {
              showDialog(
                  context: context, 
                  builder: (BuildContext context){
                    return CodeInputDialog(
                        onCodeEntered: (code) async {
                          User? user = await AuthRepository().verifyOtp(verificationId, code);
                          AuthRepository().registerUserWithPhone(loginController.text, nameController.text, user!.uid );
                          loginController.clear();
                          nameController.clear();
                          await AuthLocalStorage().saveUserId(user.uid);
                          Get.toNamed('/');
                    });
                  });
            },
            context
          );
        }

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

