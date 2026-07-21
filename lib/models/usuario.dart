import 'rol.dart';

class Usuario {
  final String id;
  final String nombres;
  final String apellidos;
  final String correo;
  final String? telefono;
  final bool activo;
  final Rol rol;

  const Usuario({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    this.telefono,
    required this.activo,
    required this.rol,
  });

  String get nombreCompleto => '$nombres $apellidos';

  bool get esAdministrador => rol.nombre == 'Administrador';

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id']?.toString() ?? '',
      nombres: json['nombres']?.toString() ?? '',
      apellidos: json['apellidos']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      activo: json['activo'] as bool? ?? true,
      rol: Rol.fromJson(Map<String, dynamic>.from(json['rol'] as Map? ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'telefono': telefono,
      'activo': activo,
      'rol': rol.toJson(),
    };
  }
}
