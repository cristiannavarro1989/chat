import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import '../models/usuario.dart';
import '../global/environment.dart';

class AuthService with ChangeNotifier {
  Usuario? _usuario;
  bool _autenticando = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final http.Client _httpClient;

  // Inyectamos el http.Client para mejor testabilidad
  AuthService({http.Client? client}) : _httpClient = client ?? http.Client();

  Usuario? get usuario => _usuario;
  bool get autenticando => _autenticando;

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  // Métodos estáticos para operaciones simples de token
  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'token');
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    try {
      autenticando = true;
      final data = {'email': email, 'password': password};

      final response = await _httpClient.post(
        Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.body);
        _usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        return true;
      }

      return false;
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } on http.ClientException catch (e) {
      throw Exception('Error de conexión: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    } finally {
      autenticando = false;
    }
  }

  Future<String> register(String nombre, String email, String password) async {
    try {
      autenticando = true;
      final data = {'nombre': nombre, 'email': email, 'password': password};

      final response = await _httpClient.post(
        Uri.parse('${Environment.apiUrl}/login/new'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.body);
        _usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        return '';
      } else {
        final respBody = jsonDecode(response.body);
        return respBody['msg'] ?? 'Error desconocido al registrar';
      }
    } on TimeoutException {
      return 'Tiempo de espera agotado';
    } on http.ClientException catch (e) {
      return 'Error de conexión: ${e.message}';
    } catch (e) {
      return 'Error inesperado: $e';
    } finally {
      autenticando = false;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      autenticando = true;
      final token = await _storage.read(key: 'token');

      if (token == null) return false;

      final response = await _httpClient.get(
        Uri.parse('${Environment.apiUrl}/login/refreshToken'),
        headers: {'Content-Type': 'application/json', 'x-token': token},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.body);
        _usuario = loginResponse.usuario;
        await _guardarToken(loginResponse.token);
        return true;
      }

      await logout();
      return false;
    } catch (e) {
      await logout();
      return false;
    } finally {
      autenticando = false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
    _usuario = null;
    notifyListeners();
  }

  Future<void> _guardarToken(String token) async {
    await _storage.write(key: 'token', value: token);
    notifyListeners();
  }
}
