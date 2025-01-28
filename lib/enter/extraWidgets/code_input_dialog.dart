import 'package:flutter/material.dart';
import 'package:messanger/theme.dart';

class CodeInputDialog extends StatefulWidget {
  final Function(String code) onCodeEntered;

  const CodeInputDialog({Key? key, required this.onCodeEntered}) : super(key: key);

  @override
  _CodeInputDialogState createState() => _CodeInputDialogState();
}

class _CodeInputDialogState extends State<CodeInputDialog> {
  List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  List<String> _code = ['', '', '', '', '', ''];

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Перевірка на введення цифри
    if (value.isNotEmpty && value.length == 1) {
      _code[index] = value; // Зберігаємо введену цифру
      if (index < 5) {
        FocusScope.of(context).nextFocus(); // Перехід до наступного поля
      }
    } else if (value.isEmpty) {
      _code[index] = ''; // Очистка коду при видаленні
      if (index > 0) {
        FocusScope.of(context).previousFocus(); // Повернення до попереднього поля
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
            onTap: (){
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
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              maxLength: 1,
              autofocus: index == 0,
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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: thirdColor), // Жирний чорний текст
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
          child: Text('Підтвердити', style: Theme.of(context).textTheme.titleMedium,),
        ),

      ],
    );
  }
}

