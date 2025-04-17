import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';


class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginState();
  }

  Future<void> _checkLoginState() async {
    await Future.delayed(Duration.zero); // Espera un ciclo de eventos

    final authService = Provider.of<AuthService>(context, listen: false);
    final isLoggedIn = await authService.isLoggedIn();

    if (!mounted) return; // Verifica si el widget todavía está en el árbol

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const UsuariosPage(),
          transitionDuration: Duration.zero,
        ),
      );
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}