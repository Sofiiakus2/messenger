import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

class CustomToggleButton extends StatefulWidget {
  const CustomToggleButton({super.key, required this.initialValue, required this.onToggle});
  final bool initialValue;
  final Function(bool) onToggle;

  @override
  State<CustomToggleButton> createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.initialValue;
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
        width: 70,
        height: 35,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isToggled ? thirdColor :Colors.red ,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: isToggled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 27,
            height: 27,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(
              isToggled ? Icons.check : Icons.close ,
              color: isToggled ? thirdColor : Colors.red ,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
