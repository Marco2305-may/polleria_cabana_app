import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/reservacion.dart';

class ReservasAdminService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Reservacion>> obtenerReservas() {
    return _db
        .collection("reservas")
        .orderBy("fechaHora", descending: false)
        .snapshots()
        .map((snap) =>
        snap.docs.map((e) => Reservacion.fromMap(e.id, e.data())).toList());
  }

  Future<String> obtenerNombreUsuario(String idUsuario) async {
    final snap = await _db.collection("usuarios").doc(idUsuario).get();
    return snap.data()?["nombre"] ?? "Usuario desconocido";
  }
}
