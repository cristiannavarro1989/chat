import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';
import '../services/auth_service.dart';
import '../widgets/button_blue.dart';
import '../widgets/custom_input.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
                Logo(text: 'Registro'),
                _Form(),
                Labels(route: 'login',title: '¿Ya tienes una cuenta?', subTitle: 'Ingresa ahora!'),
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
  final nameCtrl = TextEditingController();
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
            icon: Icons.perm_identity,
            hintText: 'Nombre',
            keyboardType: TextInputType.text,
            textEditingController: nameCtrl,
          ),
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
            text: 'Crear cuenta',
            enabled: !authService.autenticando,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final registerOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
              if (registerOk.isEmpty) {
                //Navegar a la pantalla principal
                Navigator.pushReplacementNamed(context, 'usuarios');
              }else {
                //Mostrar alerta
                mostrarAlerta(context, 'Error al registrar la cuenta', registerOk);
              }
            },
          ),
        ],
      ),
    );
  }
}
