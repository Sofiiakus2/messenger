import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:messanger/repositories/auth_local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkUserLoginStatus() async {
    String? userId = await AuthLocalStorage().getUserId();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userId != null) {
        Get.offNamed('/');
      } else {
        Get.offNamed('/login');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
