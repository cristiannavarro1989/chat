import 'dart:io';
import 'package:chat/models/mensajes_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';
import '../widgets/chat_message.dart';
import '../services/chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  ChatService chatService = ChatService();
  SocketService socketService = SocketService();
  AuthService authService = AuthService();
  List<ChatMessage> _messages = [];
  bool _estaEscribiendo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensajes);
    _cargarHistorial(chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioId);
    final history = chat.map(
      (m) => new ChatMessage(
        text: m.mensaje,
        uid: m.de,
        isMe: authService.usuario!.uid == m.de,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 400),
        )..forward(),
      ),
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensajes(dynamic data) {
    ChatMessage message = ChatMessage(
      text: data['mensaje'],
      uid: data['de'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
      isMe: authService.usuario!.uid == data['de'],
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(
                usuarioPara.nombre.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(
              usuarioPara.nombre,
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

    final newMessage = ChatMessage(
      text: value,
      isMe: true,
      uid: authService.usuario!.uid,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    _textController.clear();
    _focusNode.requestFocus();
    setState(() {});
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.emit('mensaje-personal', {
      'de': authService.usuario!.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': value,
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
