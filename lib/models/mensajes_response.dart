import 'dart:convert';

class MensajesResponse {
  final bool ok;
  final List<Mensaje> mensajes;

  MensajesResponse({
    required this.ok,
    required this.mensajes,
  });

  factory MensajesResponse.fromJson(String str) => MensajesResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MensajesResponse.fromMap(Map<String, dynamic> json) => MensajesResponse(
    ok: json["ok"],
    mensajes: List<Mensaje>.from(json["mensajes"].map((x) => Mensaje.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "ok": ok,
    "mensajes": List<dynamic>.from(mensajes.map((x) => x.toMap())),
  };
}

class Mensaje {
  final String de;
  final String para;
  final String mensaje;
  final DateTime createdAt;
  final DateTime updatedAt;

  Mensaje({
    required this.de,
    required this.para,
    required this.mensaje,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Mensaje.fromJson(String str) => Mensaje.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Mensaje.fromMap(Map<String, dynamic> json) => Mensaje(
    de: json["de"],
    para: json["para"],
    mensaje: json["mensaje"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toMap() => {
    "de": de,
    "para": para,
    "mensaje": mensaje,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
