import 'package:cloud_firestore/cloud_firestore.dart';

class Reservacion {
  final String id;
  final String detalle;
  final DateTime fechaHora;
  final String idUsuario;
  final int invitados;

  Reservacion({
    required this.id,
    required this.detalle,
    required this.fechaHora,
    required this.idUsuario,
    required this.invitados,
  });

  factory Reservacion.fromMap(String id, Map<String, dynamic> data) {
    return Reservacion(
      id: id,
      detalle: data['detalle'] ?? '',
      fechaHora: data['fecha - hora'] != null
          ? (data['fecha - hora'] as Timestamp).toDate()
          : DateTime.now(),
      idUsuario: data['id_usuario'] ?? '',
      invitados: data['invitados'] ?? 0,
    );
  }
}

