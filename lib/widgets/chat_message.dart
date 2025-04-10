import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isMe;
  final String imageUrl;
  final String uid;
  final AnimationController animationController;
  const ChatMessage({
    super.key,
    required this.text,
    required this.isMe,
    this.imageUrl = '',
    required this.uid,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: animationController,
        child: SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: animationController, curve: Curves.easeOut),
            child: Container(child: isMe ? _myMessage() : _friendMessage())));
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, right: 10, left: 50),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _friendMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, right: 50, left: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text, style: TextStyle(color: Colors.black87)),
      ),
    );
  }
}
