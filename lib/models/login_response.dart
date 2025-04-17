import 'dart:convert';

import 'package:chat/models/usuario.dart';

class LoginResponse {
  final bool ok;
  final String msg;
  final Usuario usuario;
  final String token;

  LoginResponse({
    required this.ok,
    required this.msg,
    required this.usuario,
    required this.token,
  });

  factory LoginResponse.fromJson(String str) => LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    ok: json["ok"],
    msg: json["msg"],
    usuario: Usuario.fromMap(json["usuario"]),
    token: json["token"],
  );

  Map<String, dynamic> toMap() => {
    "ok": ok,
    "msg": msg,
    "usuario": usuario.toMap(),
    "token": token,
  };
}

