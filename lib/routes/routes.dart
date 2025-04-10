import 'package:flutter/material.dart';
import '../pages/usuarios_page.dart';
import '../pages/chat_page.dart';
import '../pages/loading_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
    'usuarios': (_) => UsuariosPage(),
    'chat': (_) => ChatPage(),
    'login': (_) => LoginPage(),
    'register': (_) => RegisterPage(),
    'loading': (_) => LoadingPage(),
};