import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../models/reservacion.dart';

class ReservacionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  /// Crear una reservación
  Future<void> crearReservacion({
    required String detalle,
    required DateTime fechaHora,
    required String idUsuario,
    required int invitados,
  }) async {
    try {
      final id = _uuid.v4();

      final reservacion = Reservacion(
        id: id,
        detalle: detalle,
        fechaHora: fechaHora,
        idUsuario: idUsuario,
        invitados: invitados,
      );

      await _db.collection("reservas").doc(id).set(reservacion.toMap());
    } catch (e) {
      throw Exception("Error al crear reservación: $e");
    }
  }

  /// Obtener todas las reservas de un usuario
  Future<List<Reservacion>> obtenerReservas(String idUsuario) async {
    try {
      final query = await _db
          .collection("reservas")
          .where("idUsuario", isEqualTo: idUsuario)
          .orderBy("fechaHora", descending: true)
          .get();

      return query.docs
          .map((doc) => Reservacion.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception("Error al obtener reservas: $e");
    }
  }

  /// Obtener una reservación por ID
  Future<Reservacion?> obtenerReservacionPorId(String id) async {
    try {
      final doc = await _db.collection("reservas").doc(id).get();

      if (!doc.exists) return null;

      return Reservacion.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception("Error al obtener reservación: $e");
    }
  }

  /// Actualizar una reservación
  Future<void> actualizarReservacion(
      String id, {
        String? detalle,
        DateTime? fechaHora,
        int? invitados,
      }) async {
    try {
      final Map<String, dynamic> data = {};

      if (detalle != null) data["detalle"] = detalle;
      if (fechaHora != null) data["fechaHora"] = fechaHora;
      if (invitados != null) data["invitados"] = invitados;

      await _db.collection("reservas").doc(id).update(data);
    } catch (e) {
      throw Exception("Error al actualizar reservación: $e");
    }
  }

  /// Eliminar una reservación
  Future<void> eliminarReservacion(String id) async {
    try {
      await _db.collection("reservas").doc(id).delete();
    } catch (e) {
      throw Exception("Error al eliminar reservación: $e");
    }
  }
}
