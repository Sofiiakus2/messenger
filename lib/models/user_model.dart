import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messanger/repositories/auth_local_storage.dart';
import 'package:messanger/repositories/user_repository.dart';

import 'chat_model.dart';

class UserModel{
  String? id;
  String name;
  String? image;
  String? token;
  String email;
  bool? status;
  String? description;
  List<String>? favoriteContacts;


  UserModel({
    this.id,
    required this.name,
    this.image,
    this.token,
    required this.email,
    this.status,
    this.description,
    this.favoriteContacts
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'token': token,
      'email': email,
      'status': status,
      'description': description,
      'favoriteContacts': favoriteContacts!.isEmpty ? [] : favoriteContacts, // Перевірка на пустий список
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'],
      image: map['image'],
      token: map['token'],
      email: map['email'],
      status: map['status'],
      description: map['description'],
      favoriteContacts: map['favoriteContacts'] != null ? List<String>.from(map['favoriteContacts']) : [], // Безпечне перетворення на список
    );
  }


  static Future<UserModel?> getChatCompanion(ChatModel chat) async {
    String? currentUserId = await AuthLocalStorage().getUserId();
    if (currentUserId == null || !chat.companionsIds.contains(currentUserId)) {
      return null;
    }

    String companionId = chat.companionsIds.firstWhere((id) => id != currentUserId);

    return await UserRepository().getUser(companionId);
  }

  Future<void> addFavoriteContact(String contactId) async {

    if (favoriteContacts!.length >= 10) {
      favoriteContacts!.removeAt(0);
    }

    favoriteContacts!.add(contactId);

    await save();
  }

  Future<void> save() async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      await users.doc(id).set(toMap(), SetOptions(merge: true));

    } catch (e) {
      rethrow;
    }
  }

}
