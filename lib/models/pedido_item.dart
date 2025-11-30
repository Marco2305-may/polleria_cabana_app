class PedidoItem {
  String idComida;
  String nombre;
  int cantidad;
  double subtotal;

  PedidoItem({
    required this.idComida,
    required this.nombre,
    required this.cantidad,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      "idComida": idComida,
      "nombre": nombre,
      "cantidad": cantidad,
      "subtotal": subtotal,
    };
  }

  factory PedidoItem.fromMap(Map<String, dynamic> map) {
    return PedidoItem(
      idComida: map['idComida'],
      nombre: map['nombre'],
      cantidad: map['cantidad'],
      subtotal: (map['subtotal'] ?? 0).toDouble(),
    );
  }
}