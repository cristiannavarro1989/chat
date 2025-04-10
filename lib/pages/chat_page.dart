import 'dart:io';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
List<ChatMessage> _messages = [
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text('TA', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              'Melissa Flores',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(color: Colors.white, height: 50, child: _inputChat()),
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child:
                  Platform.isIOS
                      ? CupertinoButton(
                        onPressed:
                            (_textController.text.trim().isEmpty)
                                ? null
                                : () =>
                                    _handleSubmit(_textController.text.trim()),
                        child: Text('Enviar'),
                      )
                      : Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(Icons.send),
                            onPressed:
                                (_textController.text.trim().isEmpty)
                                    ? null
                                    : () => _handleSubmit(
                                      _textController.text.trim(),
                                    ),
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String value) {
    if (value.length == 0) return;

    final newMessage = ChatMessage(text: value, isMe: true, uid: '123', animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 400)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    _textController.clear();
    _focusNode.requestFocus();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
