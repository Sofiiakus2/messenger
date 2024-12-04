import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

class PersonalAccount extends StatelessWidget {
  const PersonalAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            Image.network(
              'https://wallart.ua/wpmd/5986-orig.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: screenSize.height * 0.6,
            ),

            Positioned(
              bottom: 0,
              child: Container(
                height: screenSize.height * 0.5,
                width: screenSize.width,
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      Text(
                        'Sofiia Kushnirenko',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                            color: Colors.white
                        ),
                        softWrap: true,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Розробник',
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontSize: 24),
                      ),
                      Text(
                        'Відділ маркетингу',
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontSize: 20),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        '+380985816594',
                        style: Theme
                            .of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(fontSize: 20, color: secondaryColor, decoration: TextDecoration.underline ),
                      ),

                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Мої контакти',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Icon(Icons.navigate_next_outlined)
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Редагувати профіль',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Icon(Icons.navigate_next_outlined)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
