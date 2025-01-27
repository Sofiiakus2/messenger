import 'package:flutter/material.dart';
import '../../../theme.dart';


class EditingBlock extends StatelessWidget {
  final Function cancelEditMessage;

  const EditingBlock({
    super.key,
    required this.cancelEditMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          margin: const EdgeInsets.only(left: 20),
          decoration: const BoxDecoration(
            color: thirdColor,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Text(
            'Редагування',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: () => cancelEditMessage(),
          child: Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(left: 5),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: const Icon(
              Icons.close,
              size: 20,
              color: thirdColor,
            ),
          ),
        ),
      ],
    );
  }
}
