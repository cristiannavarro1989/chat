import 'package:http/http.dart' as http;
import 'auth_service.dart';

import '../global/environment.dart';
import '../models/usuario.dart';
import '../models/usuarios_response.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/usuarios');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken() ?? "",
        },
      );
      final usuarios = UsuariosResponse.fromJson(response.body);
      return usuarios.usuarios;
    } catch (e) {
      print('Error al obtener usuarios: $e');
      return [];
    }
  }
}
