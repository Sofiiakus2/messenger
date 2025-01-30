import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

class CodeInputDialog extends StatefulWidget {
  final Function(String code) onCodeEntered;

  const CodeInputDialog({super.key, required this.onCodeEntered});

  @override
  _CodeInputDialogState createState() => _CodeInputDialogState();
}

class _CodeInputDialogState extends State<CodeInputDialog> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<String> _code = List.filled(6, '');

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      _code[index] = value;
      if (index < 5) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else {
      _code[index] = '';
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Введіть код'),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.close,
                color: thirdColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
      titleTextStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 22),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(6, (index) {
          return SizedBox(
            width: 50,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textInputAction: index < 5 ? TextInputAction.next : TextInputAction.done,
              maxLength: 1,
              onChanged: (value) => _onChanged(value, index),
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: thirdColor),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: '-',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: thirdColor),
            ),
          );
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String enteredCode = _code.join('');
            widget.onCodeEntered(enteredCode);
            Navigator.of(context).pop();
          },
          child: Text('Підтвердити', style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}
