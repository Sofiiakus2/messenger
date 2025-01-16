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

  Future<bool> isUserGroupOwner(String userId, String chatId) async {
    try {
      final docSnapshot = await firestore.collection('chats').doc(chatId).get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();

        if (data != null && data['owner'] == userId) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking group owner: $e');
      return false;
    }
  }

  Future<void> transferGroupOwnership(String chatId, String currentOwnerId) async {
    try {
      final chatDoc = await firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        throw Exception("Чат не знайдено");
      }

      final chatData = chatDoc.data()!;
      List<String> companionsIds = List<String>.from(chatData['companionsIds'] ?? []);
      String currentOwner = chatData['owner'];

      if (currentOwner != currentOwnerId) {
        throw Exception("Користувач не є поточним власником чату");
      }

      String? newOwnerId = companionsIds.firstWhere(
            (userId) => userId != currentOwnerId,
        orElse: () => throw Exception("Немає інших учасників для передачі власності"),
      );

      await firestore.collection('chats').doc(chatId).update({
        'owner': newOwnerId,
      });

    } catch (e) {
      rethrow;
    }
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

  Future<List<String>> getFavoriteContacts() async {
    try {
      final currentUser = auth.currentUser;
      // Отримуємо посилання на колекцію користувачів
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

      // Перевіряємо чи існує користувач
      if (userSnapshot.exists) {
        // Отримуємо список улюблених контактів
        List<dynamic> favoriteContacts = userSnapshot['favoriteContacts'] ?? [];
        return List<String>.from(favoriteContacts); // Перетворюємо в список String
      } else {
        print("User not found");
        return [];
      }
    } catch (e) {
      print('Error fetching favorite contacts: $e');
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

  Future<void> addContactToFavorites(String contactId) async {
    try {
      final currentUser = auth.currentUser;

      UserModel? user = await UserRepository().getUser(currentUser!.uid);

      await user!.addFavoriteContact(contactId);

    } catch (e) {
      rethrow;
    }
  }





}