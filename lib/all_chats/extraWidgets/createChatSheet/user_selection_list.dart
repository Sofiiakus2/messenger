import 'package:flutter/material.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../theme.dart';

class UserSelectionList extends StatefulWidget {

  final Map<UserModel, bool> selectedUsers;
  final Function(UserModel) onUserTap;

  const UserSelectionList({

    required this.selectedUsers,
    required this.onUserTap,
    super.key,
  });

  @override
  State<UserSelectionList> createState() => _UserSelectionListState();
}

class _UserSelectionListState extends State<UserSelectionList> {
  List<UserModel> users = [];

  void fetchUsers() async {
    final fetchedUsers = await UserRepository().getAllUsers();
    setState(() {
      users = fetchedUsers;
    });
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                widget.onUserTap(users[index]);
              },
              child: Container(
                height: 60,
                margin: EdgeInsets.only(left: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        color: widget.selectedUsers[users[index]] ?? false
                            ? thirdColor
                            : Colors.transparent,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                      child: widget.selectedUsers[users[index]] ?? false
                          ? Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    SizedBox(width: 15),
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: thirdColor,
                        size: 28,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      users[index].name,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
            Divider(color: Colors.white),
          ],
        );
      },
    );
  }
}
