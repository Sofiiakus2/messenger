import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: screenSize.height * 0.7,
              width: screenSize.width,
              padding: EdgeInsets.symmetric(vertical: 25),
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
                children: [
                  Text('Вхід',
                  style: Theme.of(context).textTheme.labelLarge,),

                  const SizedBox(height: 40),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                        ),
                        TextField(
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            hintText: 'yourEmail@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                             // borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Password',
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                        ),
                        TextField(
                          style: Theme.of(context).textTheme.bodySmall,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 12,
                            ),
                            hintText: '●●●●●●',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: OutlineInputBorder(
                              // borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: screenSize.width,
                    height: 80,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Відступи
                        ),
                        child: Text('Увійти', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: primaryColor, fontWeight: FontWeight.w600),)),
                  ),
                  Expanded(child: SizedBox()),
                  TextButton(
                    onPressed: (){},
                    child:  Text(
                      'Ще немає акаунту? Зареєструватися!',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)
                  ),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
