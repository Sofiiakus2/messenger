import 'chat_model.dart';

class UserModel{
  String? id;
  String name;
  String image;
  String? token;
  String phoneNumber;
  bool? status;
  String? lastMessage;
  DateTime? lastMessageTime;

  UserModel({
    this.id,
    required this.name,
    required this.image,
    this.token,
    required this.phoneNumber,
    this.status,
    this.lastMessage,
    this.lastMessageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'token': token,
      'phoneNumber': phoneNumber,
      'status': status,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      token: map['token'],
      phoneNumber: map['phoneNumber'],
      status: map['status'],
      lastMessage: map['lastMessage'],
      lastMessageTime: map['lastMessageTime']
    );
  }

  static UserModel? getChatCompanion(String currentUserId, ChatModel chat) {
    if (!chat.companionsIds.contains(currentUserId)) {
      return null;
    }

    String companionId = chat.companionsIds.firstWhere((id) => id != currentUserId);

    return users.firstWhere((user) => user.id == companionId);
  }
}



List<UserModel> users = [
  UserModel(
    id: '1',
    name: 'Anna',
    image: 'https://img.freepik.com/premium-photo/natural-beauty-portrait-woman-autumn-forest_1351942-2475.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'Hello! How are you?',
    lastMessageTime: DateTime.now(),
  ),
  UserModel(
    id: '2',
    name: 'Svitlana',
    image: 'https://img.freepik.com/premium-photo/natural-beauty-confident-young-woman-smiling-outdoors-cozy-sweater_768106-22747.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'I will be there soon!',
    lastMessageTime: DateTime.now().subtract(Duration(hours: 3)),
  ),
  UserModel(
    id: '3',
    name: 'Oleg',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2C1TfTA1kBrfjnX_GVBrodmMyJaxx6WRAe-WfLPGOxLVnMgy1GjuNNjtXvDc2cA8aeoI&usqp=CAU',
    phoneNumber: '0987654323',
    lastMessage: 'Got it, I\'ll reply later.',
    lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
  ),
  UserModel(
    id: '4',
    name: 'Nastia',
    image: 'https://img.freepik.com/premium-photo/confident-young-woman-modern-indoor-setting_1281219-1532.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'Let\'s meet tomorrow!',
    lastMessageTime: DateTime.now().subtract(Duration(days: 3)),
  ),
  UserModel(
    id: '5',
    name: 'Stas',
    image: 'https://res.cloudinary.com/dqzkirtbz/image/upload/w_auto/q_auto,f_auto,dpr_auto/v1698342290/Website/blog/male_portrait_postcrest.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'Please send me the file.',
    lastMessageTime: DateTime.now().subtract(Duration(days: 7)),
  ),
  UserModel(
    id: '6',
    name: 'Maksim Olegovich',
    image: 'https://imgcdn.stablediffusionweb.com/2024/5/2/972d3c79-b03a-42d1-841c-1baa0fb01c21.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'The project is going well.',
    lastMessageTime: DateTime.now().subtract(Duration(days: 10)),
  ),
  UserModel(
    id: '7',
    name: 'Анна Андріївна',
    image: 'https://imgcdn.stablediffusionweb.com/2024/4/8/6d0d0049-aa81-41c8-a93d-e6d70c12d4e4.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'See you next week!',
    lastMessageTime: DateTime.now().subtract(Duration(days: 30)),
  ),
  UserModel(
    id: '8',
    name: 'Robert Downey Jr.',
    image: 'https://californiamuseum.org/wp-content/uploads/robertdowneyjr_cahalloffameinductee-1.png',
    phoneNumber: '0987654323',
    lastMessage: 'Looking forward to our meeting!',
    lastMessageTime: DateTime.now().subtract(Duration(days: 45)),
  ),
  UserModel(
    id: '9',
    name: 'Benedict Cumberbatch',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcbCTns_TrthBx1w-YqqHtYvtg3qzzD9t8tw&s',
    phoneNumber: '0987654323',
    lastMessage: 'Can you send me the link?',
    lastMessageTime: DateTime.now().subtract(Duration(days: 60)),
  ),
  UserModel(
    id: '10',
    name: 'Zendaya',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTC_x7dhis4PKN4nxr_RAsSnA8e0WolQLCs0A&s',
    phoneNumber: '0987654323',
    lastMessage: 'I\'m in the office, talk later.',
    lastMessageTime: DateTime.now().subtract(Duration(days: 90)),
  ),
  UserModel(
    id: '11',
    name: 'Mark Ruffalo',
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2MV6OJZfKHOfkh14hChDvhY4Dbr4wkIzvyw&s',
    phoneNumber: '0987654323',
    lastMessage: 'Let\'s catch up soon!',
    lastMessageTime: DateTime.now().subtract(Duration(days: 120)),
  ),
  UserModel(
    id: '12',
    name: 'Chris Evans',
    image: 'https://m.media-amazon.com/images/M/MV5BMjIzOTA0OTQyN15BMl5BanBnXkFtZTcwMjE1OTIwMw@@._V1_FMjpg_UX1000_.jpg',
    phoneNumber: '0987654323',
    lastMessage: 'Waiting for your response.',
    lastMessageTime: DateTime.now().subtract(Duration(days: 180)),
  ),
];


List<String> favouriteUsers = ['1', '6', '12', '5', '10'];
