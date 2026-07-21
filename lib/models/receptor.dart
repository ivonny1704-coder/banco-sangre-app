class Receptor {
  final int? id;
  final String nombre;
  final String apellido;
  final String cedula;
  final String fechaNacimiento;
  final String genero;
  final String tipoSangre;
  final String telefono;
  final String email;
  final String direccion;
  final String estado;
  final DateTime? fechaRegistro;
  final DateTime? ultimaActualizacion;

  Receptor({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.cedula,
    required this.fechaNacimiento,
    required this.genero,
    required this.tipoSangre,
    required this.telefono,
    required this.email,
    required this.direccion,
    this.estado = 'activo',
    this.fechaRegistro,
    this.ultimaActualizacion,
  });

  // 🔹 Convertir JSON a Receptor
  factory Receptor.fromJson(Map<String, dynamic> json) {
    return Receptor(
      id: json['id'] ?? json['_id'],
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      cedula: json['cedula'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] ?? '',
      genero: json['genero'] ?? '',
      tipoSangre: json['tipoSangre'] ?? '',
      telefono: json['telefono'] ?? '',
      email: json['email'] ?? '',
      direccion: json['direccion'] ?? '',
      estado: json['estado'] ?? 'activo',
      fechaRegistro: json['fechaRegistro'] != null
          ? DateTime.parse(json['fechaRegistro'])
          : null,
      ultimaActualizacion: json['ultimaActualizacion'] != null
          ? DateTime.parse(json['ultimaActualizacion'])
          : null,
    );
  }

  // 🔹 Convertir Receptor a JSON
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'cedula': cedula,
      'fechaNacimiento': fechaNacimiento,
      'genero': genero,
      'tipoSangre': tipoSangre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'estado': estado,
    };
  }

  // 🔹 Copiar con cambios
  Receptor copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? cedula,
    String? fechaNacimiento,
    String? genero,
    String? tipoSangre,
    String? telefono,
    String? email,
    String? direccion,
    String? estado,
  }) {
    return Receptor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      cedula: cedula ?? this.cedula,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      genero: genero ?? this.genero,
      tipoSangre: tipoSangre ?? this.tipoSangre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      estado: estado ?? this.estado,
    );
  }

  // 🔹 Obtener color según tipo de sangre
  String get colorTipoSangre {
    switch (tipoSangre) {
      case 'A+': return '#D32F2F';
      case 'A-': return '#EF5350';
      case 'B+': return '#1976D2';
      case 'B-': return '#42A5F5';
      case 'AB+': return '#7B1FA2';
      case 'AB-': return '#AB47BC';
      case 'O+': return '#388E3C';
      case 'O-': return '#66BB6A';
      default: return '#9E9E9E';
    }
  }

  // 🔹 Obtener color según estado
  String get colorEstado {
    switch (estado) {
      case 'activo': return '#4CAF50';
      case 'inactivo': return '#F44336';
      case 'pendiente': return '#FF9800';
      default: return '#9E9E9E';
    }
  }

  // 🔹 Obtener emoji según tipo de sangre
  String get emojiTipoSangre {
    switch (tipoSangre) {
      case 'A+': return '🅰️+';
      case 'A-': return '🅰️-';
      case 'B+': return '🅱️+';
      case 'B-': return '🅱️-';
      case 'AB+': return '🆎+';
      case 'AB-': return '🆎-';
      case 'O+': return '🅾️+';
      case 'O-': return '🅾️-';
      default: return '🩸';
    }
  }
}