import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getTotalPedidos() async {
    final snapshot = await _db.collection('pedidos').get();
    return snapshot.docs.length;
  }

  Future<int> getPedidosPendientes() async {
    final snapshot = await _db
        .collection('pedidos')
        .where('estado', isEqualTo: 'Pendiente')
        .get();
    return snapshot.docs.length;
  }

  Future<int> getTotalUsuarios() async {
    final snapshot = await _db.collection('usuarios').get();
    return snapshot.docs.length;
  }
}
