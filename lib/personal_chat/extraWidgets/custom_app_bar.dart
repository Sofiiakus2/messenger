import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme.dart';



class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: fourthColor, size: 30,)),
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: fourthColor, size: 30,)),
        ],
      ),
    );
  }
}

