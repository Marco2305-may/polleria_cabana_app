import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String id;
  final String direccion;
  final String estado;
  final DateTime fechaHora;
  final String idUsuario;
  final String metodoPago;
  final double total;

  Pedido({
    required this.id,
    required this.direccion,
    required this.estado,
    required this.fechaHora,
    required this.idUsuario,
    required this.metodoPago,
    required this.total,
  });

  factory Pedido.fromMap(String id, Map<String, dynamic> data) {
    return Pedido(
      id: id,
      direccion: data['direccion'] ?? '',
      estado: data['estado'] ?? '',
      fechaHora: data['fecha - hora'] != null
          ? (data['fecha - hora'] as Timestamp).toDate()
          : DateTime.now(),
      idUsuario: data['id_usuario'] ?? '',
      metodoPago: data['metodo_pago'] ?? '',
      total: (data['total'] ?? 0).toDouble(),
    );
  }
}



