
import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final String text;
  final bool enabled;
  final Function onPressed;

  const ButtonBlue({super.key, required this.text,required this.onPressed, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: enabled ? () => onPressed() : null,
      style:  ButtonStyle(backgroundColor: WidgetStateProperty.all( enabled ? Colors.blue : Colors.grey.shade300 )),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18))),
      ),
    );
  }
}
