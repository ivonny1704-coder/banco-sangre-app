import 'package:flutter/material.dart';
import '../models/donacion.dart';

class DonacionProvider extends ChangeNotifier {

  final List<Donacion> _donaciones = [
    Donacion(
      id: 1,
      donante: 'Juan Pérez',
      tipoSangre: 'O+',
      cantidad: 450,
      fecha: '20/07/2026',
      observaciones: 'Donación realizada sin novedades.',
    ),
    Donacion(
      id: 2,
      donante: 'María López',
      tipoSangre: 'A+',
      cantidad: 450,
      fecha: '18/07/2026',
      observaciones: 'Paciente apta para futuras donaciones.',
    ),
  ];

  List<Donacion> get donaciones => _donaciones;

  void agregarDonacion(Donacion donacion) {
    _donaciones.add(donacion);
    notifyListeners();
  }

  void actualizarDonacion(int index, Donacion donacion) {
    _donaciones[index] = donacion;
    notifyListeners();
  }

  void eliminarDonacion(int index) {
    _donaciones.removeAt(index);
    notifyListeners();
  }

  Donacion obtenerDonacion(int index) {
    return _donaciones[index];
  }

}