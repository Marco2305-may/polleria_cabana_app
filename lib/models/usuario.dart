class Usuario {
  final String id;
  final String correo;
  final String nombre;
  final String rol;
  final String telefono;

  Usuario({
    required this.id,
    required this.correo,
    required this.nombre,
    required this.rol,
    required this.telefono,
  });

  factory Usuario.fromMap(String id, Map<String, dynamic> data) {
    return Usuario(
      id: id,
      correo: data['correo'] ?? '',
      nombre: data['nombre'] ?? '',
      rol: data['rol'] ?? '',
      telefono: data['telefono'] ?? '',
    );
  }
}
