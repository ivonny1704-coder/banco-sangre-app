class Donacion {
  final int? id;
  final String donante;
  final String tipoSangre;
  final double cantidad;
  final String fecha;
  final String observaciones;

  Donacion({
    this.id,
    required this.donante,
    required this.tipoSangre,
    required this.cantidad,
    required this.fecha,
    required this.observaciones,
  });

  factory Donacion.fromJson(Map<String, dynamic> json) {
    return Donacion(
      id: json['id'],
      donante: json['donante'] ?? '',
      tipoSangre: json['tipoSangre'] ?? '',
      cantidad: (json['cantidad'] as num?)?.toDouble() ?? 0,
      fecha: json['fecha'] ?? '',
      observaciones: json['observaciones'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'donante': donante,
      'tipoSangre': tipoSangre,
      'cantidad': cantidad,
      'fecha': fecha,
      'observaciones': observaciones,
    };
  }
}