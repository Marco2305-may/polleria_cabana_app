import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/pedido.dart';

class PedidoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener pedidos en tiempo real
  Stream<List<Pedido>> getPedidos() {
    return _db.collection('pedidos').snapshots().map(
            (snapshot) => snapshot.docs
            .map((doc) => Pedido.fromMap(doc.id, doc.data()))
            .toList());
  }

  // Actualizar estado de pedido
  Future<void> actualizarEstado(String idPedido, String nuevoEstado) async {
    await _db.collection('pedidos').doc(idPedido).update({'estado': nuevoEstado});
  }
}
