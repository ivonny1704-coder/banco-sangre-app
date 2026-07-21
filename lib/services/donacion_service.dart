import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/donacion.dart';

class DonacionService {

  // Cambia esta URL por la de tu backend
  static const String baseUrl = "http://10.0.2.2:3000/api/donaciones";

  Future<List<Donacion>> obtenerDonaciones() async {

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {

      final List<dynamic> data = json.decode(response.body);

      return data.map((e) => Donacion.fromJson(e)).toList();

    } else {

      throw Exception("Error al obtener las donaciones");

    }

  }

  Future<void> crearDonacion(Donacion donacion) async {

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json"
      },
      body: json.encode(donacion.toJson()),
    );

    if (response.statusCode != 201 &&
        response.statusCode != 200) {

      throw Exception("No se pudo registrar la donación");

    }

  }

  Future<void> actualizarDonacion(
      int id,
      Donacion donacion) async {

    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {
        "Content-Type": "application/json"
      },
      body: json.encode(donacion.toJson()),
    );

    if (response.statusCode != 200) {

      throw Exception("No se pudo actualizar");

    }

  }

  Future<void> eliminarDonacion(int id) async {

    final response = await http.delete(
      Uri.parse("$baseUrl/$id"),
    );

    if (response.statusCode != 200) {

      throw Exception("No se pudo eliminar");

    }

  }

}