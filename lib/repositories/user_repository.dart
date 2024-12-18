import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserRepository{

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<UserModel?> getUserInfo() {
    User? user =  auth.currentUser;
    return firestore.collection('users').doc(user!.uid).snapshots().map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data()!;
        return UserModel.fromMap(data, snapshot.id);
      } else {
        return null;
      }
    });
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return [];  
      }

      final querySnapshot = await firestore.collection('users').get();

      return querySnapshot.docs
          .where((doc) => doc.id != currentUser.uid)
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final companionSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (companionSnapshot.exists) {
        return UserModel.fromMap(companionSnapshot.data()!, companionSnapshot.id);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }




}