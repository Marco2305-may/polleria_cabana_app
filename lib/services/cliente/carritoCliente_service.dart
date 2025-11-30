import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/pedido_item.dart';
import 'package:flutter/foundation.dart';

class CarritoClienteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ValueNotifier para poder usarlo en ValueListenableBuilder
  final ValueNotifier<List<PedidoItem>> itemsNotifier = ValueNotifier([]);

  CarritoClienteService() {
    // opcional: inicializar o escuchar cambios en Firestore
  }

  // Escuchar carrito en tiempo real y actualizar el notifier
  Stream<List<PedidoItem>> obtenerCarritoStream(String idUsuario) {
    return _db
        .collection('carritos')
        .doc(idUsuario)
        .collection('items')
        .snapshots()
        .map((snap) {
      final items = snap.docs.map((doc) => PedidoItem.fromMap(doc.data())).toList();
      itemsNotifier.value = items; // actualizamos el ValueNotifier
      return items;
    });
  }

  // Agregar item al carrito
  Future<void> agregarAlCarrito(PedidoItem item, String idUsuario) async {
    final docRef =
    _db.collection('carritos').doc(idUsuario).collection('items').doc(item.idComida);

    final doc = await docRef.get();
    if (doc.exists) {
      final existingItem = PedidoItem.fromMap(doc.data()!);
      final updatedItem = PedidoItem(
        idComida: existingItem.idComida,
        nombre: existingItem.nombre,
        cantidad: existingItem.cantidad + item.cantidad,
        subtotal: existingItem.subtotal + item.subtotal,
      );
      await docRef.set(updatedItem.toMap());
    } else {
      await docRef.set(item.toMap());
    }
    // Actualizamos el notifier
    final currentItems = List<PedidoItem>.from(itemsNotifier.value);
    final index = currentItems.indexWhere((i) => i.idComida == item.idComida);
    if (index >= 0) {
      currentItems[index] = PedidoItem(
        idComida: item.idComida,
        nombre: item.nombre,
        cantidad: currentItems[index].cantidad + item.cantidad,
        subtotal: currentItems[index].subtotal + item.subtotal,
      );
    } else {
      currentItems.add(item);
    }
    itemsNotifier.value = currentItems;
  }

  // Eliminar item
  Future<void> eliminarItem(String idUsuario, String idComida) async {
    final docRef =
    _db.collection('carritos').doc(idUsuario).collection('items').doc(idComida);

    await docRef.delete();

    // Actualizamos el notifier
    itemsNotifier.value = itemsNotifier.value.where((i) => i.idComida != idComida).toList();
  }

  // Vaciar carrito
  Future<void> vaciarCarrito(String idUsuario) async {
    final itemsSnap = await _db.collection('carritos').doc(idUsuario).collection('items').get();
    for (var doc in itemsSnap.docs) {
      await doc.reference.delete();
    }
    itemsNotifier.value = [];
  }
}









