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


  UserModel({
    this.id,
    required this.name,
    this.image,
    this.token,
    required this.email,
    this.status,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'token': token,
      'email': email,
      'status': status,
      'description':description
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



}
