import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receptor.dart';
import 'api_service.dart';

class ReceptorService {
  final ApiService _api = ApiService();

  // 🔹 GET - Obtener todos los receptores
  Future<List<Receptor>> getReceptores() async {
    try {
      final response = await _api.get('/receptores');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> receptores = data['data'];
          return receptores.map((json) => Receptor.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error en getReceptores: $e');
      throw Exception('Error al cargar receptores');
    }
  }

  // 🔹 GET - Obtener receptor por ID
  Future<Receptor?> getReceptorById(int id) async {
    try {
      final response = await _api.get('/receptores/$id');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Receptor.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error en getReceptorById: $e');
      return null;
    }
  }

  // 🔹 GET - Obtener receptores por tipo de sangre
  Future<List<Receptor>> getReceptoresByTipoSangre(String tipoSangre) async {
    try {
      final response = await _api.get('/receptores/tipo-sangre/$tipoSangre');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> receptores = data['data'];
          return receptores.map((json) => Receptor.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error en getReceptoresByTipoSangre: $e');
      return [];
    }
  }

  // 🔹 POST - Crear receptor
  Future<Receptor?> createReceptor(Receptor receptor) async {
    try {
      final response = await _api.post(
        '/receptores',
        body: receptor.toJson(),
      );
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Receptor.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error en createReceptor: $e');
      throw Exception('Error al crear receptor');
    }
  }

  // 🔹 PUT - Actualizar receptor
  Future<Receptor?> updateReceptor(int id, Receptor receptor) async {
    try {
      final response = await _api.put(
        '/receptores/$id',
        body: receptor.toJson(),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Receptor.fromJson(data['data']);
        }
      }
      return null;
    } catch (e) {
      print('❌ Error en updateReceptor: $e');
      throw Exception('Error al actualizar receptor');
    }
  }

  // 🔹 DELETE - Eliminar receptor
  Future<bool> deleteReceptor(int id) async {
    try {
      final response = await _api.delete('/receptores/$id');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['success'] == true;
      }
      return false;
    } catch (e) {
      print('❌ Error en deleteReceptor: $e');
      return false;
    }
  }

  // 🔹 GET - Obtener receptores por estado
  Future<List<Receptor>> getReceptoresByEstado(String estado) async {
    try {
      final response = await _api.get('/receptores/estado/$estado');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> receptores = data['data'];
          return receptores.map((json) => Receptor.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error en getReceptoresByEstado: $e');
      return [];
    }
  }
}