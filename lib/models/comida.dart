class Comida {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagen;
  final double precio;
  final String tipo;

  Comida({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.precio,
    required this.tipo,
  });

  factory Comida.fromMap(String id, Map<String, dynamic> data) {
    return Comida(
      id: id,
      nombre: data['nombre'] ?? '',
      descripcion: data['descripcion'] ?? '',
      imagen: data['imagen'] ?? '',
      precio: (data['precio'] ?? 0).toDouble(),
      tipo: data['tipo'] ?? '',
    );
  }
}
