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
      fechaHora: data['fechaHora'] != null
          ? (data['fechaHora'] as Timestamp).toDate()
          : DateTime.now(),
      idUsuario: data['idUsuario'] ?? '',
      invitados: data['invitados'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'detalle': detalle,
      'fechaHora': fechaHora,
      'idUsuario': idUsuario,
      'invitados': invitados,
    };
  }
}

