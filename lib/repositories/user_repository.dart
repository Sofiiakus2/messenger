import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message_model.dart';
import '../models/user_model.dart';
import 'messages_repository.dart';

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

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      if (userIds.isEmpty) {
        return [];
      }

      final querySnapshot = await firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching users by IDs: $e');
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

  Future<void> removeUserFromChat(String chatId, String userId) async {
    try {
      final docRef = firestore.collection('chats').doc(chatId);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<dynamic> companionsIds = docSnapshot.data()?['companionsIds'] ?? [];

        companionsIds.remove(userId);

        await docRef.update({'companionsIds': companionsIds});

        MessageModel newMessage = MessageModel(
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: 'Користувача видалено з чату',
            time: DateTime.now(),
            status: false,
            isEdited: false,
            messageType: MessageType.noti
        );

        await MessagesRepository().sendMessage(chatId, newMessage);
      } else {
        throw Exception("Чат з ID $chatId не знайдено.");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeChatFromUser(String chatId, String userId) async {
    try {
      final userRef = firestore.collection('users').doc(userId);

      await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          List<String> chats = List<String>.from(data['chats'] ?? []);

          chats.remove(chatId);

          transaction.update(userRef, {'chats': chats});
        } else {
          throw Exception("Користувач не знайдений.");
        }
      });
    } catch (e) {
      rethrow;
    }
  }




}