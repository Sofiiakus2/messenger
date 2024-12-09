import 'package:flutter/material.dart';
import 'package:messanger/models/user_model.dart';

import '../../theme.dart';

class FavouriteContacts extends StatelessWidget {
  FavouriteContacts({
    super.key,
  });

  List<UserModel> favouriteUserDetails = users
      .where((user) => favouriteUsers.contains(user.id))
      .toList();

  String formatName(String name) {
    if (name.contains(' ')) {
      return '${name.split(' ')[0]}...';
    } else if (name.length > 6) {
      return '${name.substring(0, 6)}...';
    } else {
      return name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: 250,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 20,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20, bottom: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Улюблені контакти', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold,),),
                const Icon(Icons.more_horiz)
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: favouriteUsers.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundImage: NetworkImage(favouriteUserDetails[index].image!),
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatName(favouriteUserDetails[index].name),
                          style: Theme.of(context).textTheme.labelSmall,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
