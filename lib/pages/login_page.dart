import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';
import '../services/auth_service.dart';
import '../widgets/button_blue.dart';
import '../widgets/custom_input.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(text: "Messenger"),
                _Form(),
                Labels(route: 'register'),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(
      context,
    );

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.email_outlined,
            hintText: 'Correo electronico',
            keyboardType: TextInputType.emailAddress,
            textEditingController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            hintText: 'Contraseña',
            textEditingController: passCtrl,
            isPassword: true,
          ),

          SizedBox(height: 20),

          ButtonBlue(
            text: 'Ingresar',
            enabled: !authService.autenticando,
            onPressed: () async {
              FocusScope.of(context).unfocus();
             final loginOk = await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
             if (loginOk) {
               Navigator.pushReplacementNamed(context, 'usuarios');
             }else {
               //Mostrar alerta
               mostrarAlerta(context, 'Login incorrecto', 'Revise sus credenciales');
             }
            },
          ),
        ],
      ),
    );
  }
}
