import 'package:flutter/material.dart';

import '../../theme.dart';

class CustomLoginToggle extends StatefulWidget {
  const CustomLoginToggle({super.key, required this.onToggle, required this.initialValue});
  final Function(bool) onToggle;
  final bool initialValue;

  @override
  State<CustomLoginToggle> createState() => _CustomLoginToggleState();
}

class _CustomLoginToggleState extends State<CustomLoginToggle> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isToggled = !isToggled;
        });
        widget.onToggle(isToggled);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 40,
        height: 20,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isToggled ? primaryColor :Colors.grey[400] ,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              isToggled ? Icons.local_post_office : Icons.phone ,
              color: isToggled ? primaryColor : Colors.grey[400] ,
              size: 10,
            ),
          ),
        ),
      ),
    );
  }
}
