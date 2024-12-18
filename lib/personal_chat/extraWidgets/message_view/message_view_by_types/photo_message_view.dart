import 'package:flutter/material.dart';

import '../../../../theme.dart';

class PhotoMessageView extends StatelessWidget {
  const PhotoMessageView({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: thirdColor.withOpacity(0.3),
        borderRadius: BorderRadius.all(Radius.circular(10),),
      ),
    );
  }
}
