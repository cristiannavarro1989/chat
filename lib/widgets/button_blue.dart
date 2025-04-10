
import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final String text;
  final Function onPressed;

  const ButtonBlue({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: () => onPressed(),
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blue)),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18))),
      ),
    );
  }
}
