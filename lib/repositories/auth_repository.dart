import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository{
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> registerUserWithEmail(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      await firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
      });

    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, ) async {

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Автоматичне завершення верифікації (якщо можливо)
        //UserCredential userCredential = await auth.signInWithCredential(credential);
        print('Автоматична верифікація успішна: ');
      },
      verificationFailed: (FirebaseAuthException e) {
        // Обробка помилок
        print('Помилка верифікації: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Збереження verificationId для подальшого використання
        print('Код надіслано. Verification ID: $verificationId');
      //  onCodeSent(verificationId); // Передача verificationId у callback
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Таймаут для автоматичного отримання коду
        print('Час очікування завершився. Verification ID: $verificationId');
      },

    );
  }


  Future<void> registerUserWithPhone(String phoneNumber, String verificationId, String smsCode, String name) async {
    try {
      // Створення PhoneAuthCredential за допомогою verificationId і smsCode
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Використовуємо отриману облікову інформацію для входу
      UserCredential userCredential = await auth.signInWithCredential(phoneAuthCredential);

      String userId = userCredential.user!.uid;

      // Збереження додаткових даних користувача в Firestore
      await firestore.collection('users').doc(userId).set({
        'name': name,
        'phone': phoneNumber,
      });
    } catch (e) {
      rethrow;
    }
  }


  Future<User?> loginUserWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> loginUserWithPhone(String verificationId, String smsCode) async {
    try {
      // Створення PhoneAuthCredential за допомогою verificationId і smsCode
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // Використовуємо отриману облікову інформацію для входу
      UserCredential userCredential = await auth.signInWithCredential(phoneAuthCredential);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

}