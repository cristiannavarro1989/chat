import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController? textEditingController;
  final TextInputType keyboardType;
  final bool isPassword;

  const CustomInput({super.key, required this.icon, required this.hintText, this.textEditingController, this.keyboardType = TextInputType.text , this.isPassword = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 3,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: textEditingController ,
        autocorrect: false,
        keyboardType: keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText:   hintText,
          prefixIcon: Icon(icon),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
