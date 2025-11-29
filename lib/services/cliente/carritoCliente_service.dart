import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/carrito_item.dart';

class CarritoClienteService {
  final _db = FirebaseFirestore.instance;

  // Obtener carrito del usuario dentro de pedido_temp
  Stream<List<CarritoItem>> obtenerCarrito(String idUsuario) {
    return _db
        .collection('pedido_temp')
        .doc(idUsuario)
        .collection('carrito')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => CarritoItem.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Agregar item al carrito
  Future<void> agregarAlCarrito(CarritoItem item, String idUsuario) async {
    print("AGREGAR AL CARRITO ID --> $idUsuario");
    print("ITEM --> ${item.idComida} - cant ${item.cantidad}");
    if (idUsuario.isEmpty) {
      throw Exception("ERROR: idUsuario vacío. No se puede agregar al carrito.");
    }

    await _db
        .collection('pedido_temp')
        .doc(idUsuario)
        .collection('carrito')
        .doc() // genera ID automático correcto
        .set(item.toMap());
  }

  // Vaciar carrito
  Future<void> vaciarCarrito(String idUsuario) async {
    final ref = _db
        .collection('pedido_temp')
        .doc(idUsuario)
        .collection('carrito');

    final docs = await ref.get();
    for (var d in docs.docs) {
      await d.reference.delete();
    }
  }

  // Actualizar cantidad
  Future<void> actualizarCantidad(
      String idUsuario, String idItem, int nuevaCantidad) async {
    final ref = _db
        .collection('pedido_temp')
        .doc(idUsuario)
        .collection('carrito')
        .doc(idItem);

    final snapshot = await ref.get();
    if (!snapshot.exists) return;

    final data = snapshot.data()!;
    final precioUnitario = (data['subtotal'] / data['cantidad']);

    await ref.update({
      'cantidad': nuevaCantidad,
      'subtotal': nuevaCantidad * precioUnitario,
    });
  }

  // Eliminar un item
  Future<void> eliminarItem(String idUsuario, String idItem) async {
    await _db
        .collection('pedido_temp')
        .doc(idUsuario)
        .collection('carrito')
        .doc(idItem)
        .delete();
  }

}



