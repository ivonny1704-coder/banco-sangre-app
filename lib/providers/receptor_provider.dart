import 'package:flutter/material.dart';
import '../models/receptor.dart';
import '../services/receptor_service.dart';

class ReceptorProvider extends ChangeNotifier {
  final ReceptorService _service = ReceptorService();
  
  List<Receptor> _receptores = [];
  bool _isLoading = false;
  String _error = '';
  String _mensaje = '';

  // 🔹 Getters
  List<Receptor> get receptores => _receptores;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get mensaje => _mensaje;
  int get count => _receptores.length;

  // 🔹 Listar todos los receptores
  Future<void> loadReceptores() async {
    _setLoading(true);
    _error = '';
    
    try {
      _receptores = await _service.getReceptores();
      _mensaje = '✅ ${_receptores.length} receptores cargados';
    } catch (e) {
      _error = e.toString();
      _mensaje = '❌ Error: $_error';
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Obtener receptor por ID
  Future<Receptor?> getReceptorById(int id) async {
    try {
      return await _service.getReceptorById(id);
    } catch (e) {
      _error = e.toString();
      return null;
    }
  }

  // 🔹 Crear receptor
  Future<bool> createReceptor(Receptor receptor) async {
    _setLoading(true);
    _error = '';
    
    try {
      final nuevo = await _service.createReceptor(receptor);
      if (nuevo != null) {
        _receptores.add(nuevo);
        _mensaje = '✅ Receptor creado exitosamente';
        notifyListeners();
        return true;
      } else {
        _error = 'No se pudo crear el receptor';
        _mensaje = '❌ $_error';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _mensaje = '❌ Error: $_error';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Actualizar receptor
  Future<bool> updateReceptor(int id, Receptor receptor) async {
    _setLoading(true);
    _error = '';
    
    try {
      final actualizado = await _service.updateReceptor(id, receptor);
      if (actualizado != null) {
        final index = _receptores.indexWhere((r) => r.id == id);
        if (index != -1) {
          _receptores[index] = actualizado;
        }
        _mensaje = '✅ Receptor actualizado exitosamente';
        notifyListeners();
        return true;
      } else {
        _error = 'No se pudo actualizar el receptor';
        _mensaje = '❌ $_error';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _mensaje = '❌ Error: $_error';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Eliminar receptor
  Future<bool> deleteReceptor(int id) async {
    _setLoading(true);
    _error = '';
    
    try {
      final success = await _service.deleteReceptor(id);
      if (success) {
        _receptores.removeWhere((r) => r.id == id);
        _mensaje = '✅ Receptor eliminado exitosamente';
        notifyListeners();
        return true;
      } else {
        _error = 'No se pudo eliminar el receptor';
        _mensaje = '❌ $_error';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _mensaje = '❌ Error: $_error';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Filtrar por tipo de sangre
  Future<void> filterByTipoSangre(String tipoSangre) async {
    _setLoading(true);
    _error = '';
    
    try {
      if (tipoSangre.isEmpty) {
        await loadReceptores();
      } else {
        _receptores = await _service.getReceptoresByTipoSangre(tipoSangre);
        _mensaje = '✅ ${_receptores.length} receptores con sangre $tipoSangre';
      }
    } catch (e) {
      _error = e.toString();
      _mensaje = '❌ Error: $_error';
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Filtrar por estado
  Future<void> filterByEstado(String estado) async {
    _setLoading(true);
    _error = '';
    
    try {
      if (estado.isEmpty) {
        await loadReceptores();
      } else {
        _receptores = await _service.getReceptoresByEstado(estado);
        _mensaje = '✅ ${_receptores.length} receptores con estado $estado';
      }
    } catch (e) {
      _error = e.toString();
      _mensaje = '❌ Error: $_error';
    } finally {
      _setLoading(false);
    }
  }

  // 🔹 Limpiar mensajes
  void clearMessages() {
    _mensaje = '';
    _error = '';
    notifyListeners();
  }

  // 🔹 Helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // 🔹 Reset
  void reset() {
    _receptores = [];
    _isLoading = false;
    _error = '';
    _mensaje = '';
    notifyListeners();
  }
}