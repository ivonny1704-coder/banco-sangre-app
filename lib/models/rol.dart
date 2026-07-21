class Rol {
  final String id;
  final String nombre;
  final String? descripcion;
  final bool activo;

  const Rol({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.activo,
  });

  factory Rol.fromJson(Map<String, dynamic> json) {
    return Rol(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      activo: json['activo'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'activo': activo,
    };
  }
}
