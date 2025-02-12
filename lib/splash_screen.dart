import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:messanger/repositories/auth_local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();

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

  Future<bool> authenticateUser() async {
    try {
      bool isBiometricAvailable = await _localAuthentication.canCheckBiometrics;
      if (!isBiometricAvailable) {
        print('Біометрія недоступна');
        return false;
      }
      return await _localAuthentication.authenticate(
        localizedReason: 'Authenticate using biometrics',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Помилка під час біометричної автентифікації: $e');
      return false;
    }
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
