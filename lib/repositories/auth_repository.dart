import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

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


  Future<void> registerUserWithPhone(String phone, String name, String Id) async {
    try {
      await firestore.collection('users').doc(Id).set({
        'name': name,
        'phone': phone,
      });

    } catch (e) {
      rethrow;
    }
  }

  Future<User?> loginUserWithPhone(String phone, String password) async {
    try {

      // UserCredential userCredential = await auth.signInWithPhoneNumber(
      //   phone: phone
      // );

     // return userCredential.user;
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> sendOtp(
      String phoneNumber,
      Function(String verificationId) codeSent,
      BuildContext context
      ) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted:  (PhoneAuthCredential credential) {
        //await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number auto-verified',
              style: Theme.of(context).textTheme.bodyLarge,),
            backgroundColor: thirdColor,
            duration: Duration(seconds: 3),
          ),
        );
        print("Phone number auto-verified!");
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed',
            style: Theme.of(context).textTheme.bodyLarge,),
            backgroundColor: thirdColor,
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
        print("Code sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("codeAutoRetrievalTimeout");
      },
    );
  }

  Future<User?> verifyOtp(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error verifying OTP: $e");
      return null;
    }
  }

}