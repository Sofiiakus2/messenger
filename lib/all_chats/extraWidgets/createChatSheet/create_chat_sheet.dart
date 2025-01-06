import 'package:flutter/material.dart';

import '../../../theme.dart';

class CreateChatSheet extends StatelessWidget {
  const CreateChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        height: screenSize.height - 100,
        width: screenSize.width,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Скасувати',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: thirdColor,
                        decoration: TextDecoration.underline,
                        decorationColor: thirdColor,
                      ),
                    ),
                  ),
                  Text(
                    'Написати',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 50),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Пошук',
                  hintStyle: Theme.of(context).textTheme.labelSmall,
                  filled: true,
                  fillColor: thirdColor.withOpacity(0.4),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,),
              width: screenSize.width,
             // height: 300,
              color: thirdColor.withOpacity(0.4),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.people_outline, color: Colors.white, size: 30,),
                    title: Text('Нова група', style: Theme.of(context).textTheme.labelMedium,),
                  ),
                  Divider(color: Colors.white,),
                  ListTile(
                    leading: Icon(Icons.person_add_alt, color: Colors.white, size: 30,),
                    title: Text('Новий контакт', style: Theme.of(context).textTheme.labelMedium,),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Контакти', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: thirdColor),),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,),
              width: screenSize.width,
              height: 300,
              color: thirdColor.withOpacity(0.4),
            )
          ],
        ),
      ),
    );
  }
}
