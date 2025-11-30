import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:polleria_cabana_dev/models/pedido_item.dart';

class Pedido {
  String id; // ID único del pedido
  String idUsuario;
  String direccion;
  double lat;
  double lng;
  String metodoPago;
  String estado; // Ej: "Pendiente", "Enviado", "Entregado"
  DateTime fechaHora;
  double total;
  List<PedidoItem> items; // Lista de productos en el pedido

  Pedido({
    required this.id,
    required this.idUsuario,
    required this.direccion,
    required this.lat,
    required this.lng,
    required this.metodoPago,
    required this.estado,
    required this.fechaHora,
    required this.total,
    required this.items,
  });

  // Convertir a Map para Firestore
  Map<String, dynamic> toMap() {
    return {
      "idUsuario": idUsuario,
      "direccion": direccion,
      "lat": lat,
      "lng": lng,
      "metodoPago": metodoPago,
      "estado": estado,
      "fechaHora": fechaHora,
      "total": total,
      "items": items.map((item) => item.toMap()).toList(),
    };
  }

  // Crear Pedido desde Firestore
  factory Pedido.fromMap(String id, Map<String, dynamic> data) {
    return Pedido(
      id: id,
      idUsuario: data['idUsuario'] ?? '',
      direccion: data['direccion'] ?? '',
      lat: data['lat'] ?? 0.0,
      lng: data['lng'] ?? 0.0,
      metodoPago: data['metodoPago'] ?? '',
      estado: data['estado'] ?? 'Pendiente',
      fechaHora: (data['fechaHora'] as Timestamp?)?.toDate() ?? DateTime.now(),
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      items: (data['items'] as List<dynamic>?)
          ?.map((e) => PedidoItem.fromMap(e))
          .toList() ??
          [],
    );
  }

}







