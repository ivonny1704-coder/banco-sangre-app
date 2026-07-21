import 'package:flutter/foundation.dart';

import '../models/usuario.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  Usuario? _usuario;
  bool _cargando = false;
  bool _inicializando = true;
  String? _error;

  Usuario? get usuario => _usuario;
  bool get cargando => _cargando;
  bool get inicializando => _inicializando;
  String? get error => _error;

  bool get autenticado => _usuario != null;
  bool get esAdministrador => _usuario?.esAdministrador ?? false;

  Future<void> cargarSesion() async {
    _inicializando = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _authService.obtenerUsuarioGuardado();
    } catch (_) {
      _usuario = null;
    } finally {
      _inicializando = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String correo,
    required String contrasena,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final respuesta = await _authService.login(
        correo: correo,
        contrasena: contrasena,
      );

      await _authService.guardarSesion(
        token: respuesta.token,
        usuario: respuesta.usuario,
      );

      _usuario = respuesta.usuario;

      return true;
    } catch (error) {
      _error = _limpiarMensaje(error);
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> registro({
    required String nombres,
    required String apellidos,
    required String correo,
    required String contrasena,
    String? telefono,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final respuesta = await _authService.registro(
        nombres: nombres,
        apellidos: apellidos,
        correo: correo,
        contrasena: contrasena,
        telefono: telefono,
      );

      await _authService.guardarSesion(
        token: respuesta.token,
        usuario: respuesta.usuario,
      );

      _usuario = respuesta.usuario;

      return true;
    } catch (error) {
      _error = _limpiarMensaje(error);
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cerrarSesion() async {
    await _authService.cerrarSesion();

    _usuario = null;
    _error = null;

    notifyListeners();
  }

  void limpiarError() {
    _error = null;
    notifyListeners();
  }

  String _limpiarMensaje(Object error) {
    return error.toString().replaceFirst('Exception: ', '').trim();
  }
}
