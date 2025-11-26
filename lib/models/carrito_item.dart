class CarritoItem {
  final String id;
  final int cantidad;
  final String idComida;
  final double subtotal;

  CarritoItem({
    required this.id,
    required this.cantidad,
    required this.idComida,
    required this.subtotal,
  });

  factory CarritoItem.fromMap(String id, Map<String, dynamic> data) {
    return CarritoItem(
      id: id,
      cantidad: data['cantidad'] ?? 0,
      idComida: data['id_comida'] ?? '',
      subtotal: (data['subtotal'] ?? 0).toDouble(),
    );
  }
}
