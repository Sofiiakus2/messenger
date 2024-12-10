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



List<UserModel> users = [
  UserModel(
    id: '1',
    name: 'Anna',
    image: 'https://img.freepik.com/premium-photo/natural-beauty-portrait-woman-autumn-forest_1351942-2475.jpg',
    email: '0987654323',

  ),
  UserModel(
    id: '2',
    name: 'Svitlana',
    image: 'https://img.freepik.com/premium-photo/natural-beauty-confident-young-woman-smiling-outdoors-cozy-sweater_768106-22747.jpg',
    email: '0987654323',

  ),
  UserModel(
    id: '3',
    name: 'Oleg',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2C1TfTA1kBrfjnX_GVBrodmMyJaxx6WRAe-WfLPGOxLVnMgy1GjuNNjtXvDc2cA8aeoI&usqp=CAU',
    email: '0987654323',

  ),
  UserModel(
    id: '4',
    name: 'Nastia',
    image: 'https://img.freepik.com/premium-photo/confident-young-woman-modern-indoor-setting_1281219-1532.jpg',
    email: '0987654323',

  ),
  UserModel(
    id: '5',
    name: 'Stas',
    image: 'https://res.cloudinary.com/dqzkirtbz/image/upload/w_auto/q_auto,f_auto,dpr_auto/v1698342290/Website/blog/male_portrait_postcrest.jpg',
    email: '0987654323',

  ),
  UserModel(
    id: '6',
    name: 'Maksim Olegovich',
    image: 'https://imgcdn.stablediffusionweb.com/2024/5/2/972d3c79-b03a-42d1-841c-1baa0fb01c21.jpg',
    email: '0987654323',
  ),
  UserModel(
    id: '7',
    name: 'Анна Андріївна',
    image: 'https://imgcdn.stablediffusionweb.com/2024/4/8/6d0d0049-aa81-41c8-a93d-e6d70c12d4e4.jpg',
    email: '0987654323',
  ),
  UserModel(
    id: '8',
    name: 'Robert Downey Jr.',
    image: 'https://californiamuseum.org/wp-content/uploads/robertdowneyjr_cahalloffameinductee-1.png',
    email: '0987654323',
  ),
  UserModel(
    id: '9',
    name: 'Benedict Cumberbatch',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcbCTns_TrthBx1w-YqqHtYvtg3qzzD9t8tw&s',
    email: '0987654323',
  ),
  UserModel(
    id: '10',
    name: 'Zendaya',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTC_x7dhis4PKN4nxr_RAsSnA8e0WolQLCs0A&s',
    email: '0987654323',
  ),
  UserModel(
    id: '11',
    name: 'Mark Ruffalo',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2MV6OJZfKHOfkh14hChDvhY4Dbr4wkIzvyw&s',
    email: '0987654323',
  ),
  UserModel(
    id: '12',
    name: 'Chris Evans',
    image: 'https://m.media-amazon.com/images/M/MV5BMjIzOTA0OTQyN15BMl5BanBnXkFtZTcwMjE1OTIwMw@@._V1_FMjpg_UX1000_.jpg',
    email: '0987654323',
  ),
];


List<String> favouriteUsers = ['1', '6', '12', '5', '10'];
