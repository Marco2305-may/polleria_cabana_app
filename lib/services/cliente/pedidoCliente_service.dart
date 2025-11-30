import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../models/pedido.dart';
import '../../models/pedido_item.dart';

class PedidoClienteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Crear un nuevo pedido
  Future<void> crearPedido({
    required String idUsuario,
    required String direccion,
    required double lat,
    required double lng,
    required String metodoPago,
    required List<PedidoItem> items,
  }) async {
    if (items.isEmpty) {
      throw Exception("El pedido no puede estar vacío");
    }

    double total = items.fold(0, (sum, item) => sum + item.subtotal);

    final pedido = Pedido(
      id: _uuid.v4(),
      idUsuario: idUsuario,
      direccion: direccion,
      lat: lat,
      lng: lng,
      metodoPago: metodoPago,
      estado: "Pendiente",
      fechaHora: DateTime.now(),
      total: total,
      items: items,
    );

    await _db.collection("pedidos").doc(pedido.id).set(pedido.toMap());
  }

  // Obtener todos los pedidos de un usuario
  Future<List<Pedido>> obtenerPedidos(String idUsuario) async {
    final query = await _db
        .collection("pedidos")
        .where("idUsuario", isEqualTo: idUsuario)
        .orderBy("fechaHora", descending: true)
        .get();

    return query.docs
        .map((doc) => Pedido.fromMap(doc.id, doc.data()))
        .toList();
  }
  // Eliminar pedido
  Future<void> eliminarPedido(String idPedido) async {
    await _db.collection("pedidos").doc(idPedido).delete();
  }

  // Actualizar estado de pedido
  Future<void> actualizarEstado(String idPedido, String nuevoEstado) async {
    await _db.collection("pedidos").doc(idPedido).update({"estado": nuevoEstado});
  }
}









