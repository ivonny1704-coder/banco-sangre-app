import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/constants.dart';
import '../models/usuario.dart';

class AuthResponse {
  final Usuario usuario;
  final String token;

  const AuthResponse({required this.usuario, required this.token});
}

class AuthService {
  Future<AuthResponse> login({
    required String correo,
    required String contrasena,
  }) async {
    final response = await http
        .post(
          Uri.parse('${AppConstants.apiUrl}/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'correo': correo.trim().toLowerCase(),
            'contrasena': contrasena,
          }),
        )
        .timeout(const Duration(seconds: 15));

    return _procesarRespuesta(response);
  }

  Future<AuthResponse> registro({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    String? telefono,
  }) async {
    final response = await http
        .post(
          Uri.parse('${AppConstants.apiUrl}/auth/registro'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombres': nombres.trim(),
            'apellidos': apellidos.trim(),
            'correo': correo.trim().toLowerCase(),
            'contrasena': contrasena,
            'telefono': telefono?.trim().isEmpty == true
                ? null
                : telefono?.trim(),
          }),
        )
        .timeout(const Duration(seconds: 15));

    return _procesarRespuesta(response);
  }

  Future<void> guardarSesion({
    required String token,
    required Usuario usuario,
  }) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(AppConstants.tokenKey, token);

    await preferences.setString(
      AppConstants.usuarioKey,
      jsonEncode(usuario.toJson()),
    );
  }

  Future<String?> obtenerToken() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(AppConstants.tokenKey);
  }

  Future<Usuario?> obtenerUsuarioGuardado() async {
    final preferences = await SharedPreferences.getInstance();

    final usuarioJson = preferences.getString(AppConstants.usuarioKey);

    if (usuarioJson == null || usuarioJson.isEmpty) {
      return null;
    }

    try {
      return Usuario.fromJson(
        Map<String, dynamic>.from(jsonDecode(usuarioJson) as Map),
      );
    } catch (_) {
      await cerrarSesion();
      return null;
    }
  }

  Future<void> cerrarSesion() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(AppConstants.tokenKey);
    await preferences.remove(AppConstants.usuarioKey);
  }

  AuthResponse _procesarRespuesta(http.Response response) {
    Map<String, dynamic> cuerpo;

    try {
      cuerpo = Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      throw Exception('La respuesta del servidor no es válida');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        cuerpo['mensaje']?.toString() ?? 'No se pudo completar la solicitud',
      );
    }

    final datos = Map<String, dynamic>.from(cuerpo['datos'] as Map? ?? {});

    final usuarioJson = Map<String, dynamic>.from(
      datos['usuario'] as Map? ?? {},
    );

    final token = datos['token']?.toString() ?? '';

    if (token.isEmpty || usuarioJson.isEmpty) {
      throw Exception('La respuesta de autenticación está incompleta');
    }

    return AuthResponse(usuario: Usuario.fromJson(usuarioJson), token: token);
  }
}
