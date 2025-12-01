import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../models/comida.dart';

class ComidaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener todas las comidas en tiempo real
  Stream<List<Comida>> getComidas() {
    return _db.collection('comidas').snapshots().map(
          (snapshot) => snapshot.docs
          .map((doc) => Comida.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  // Agregar nueva comida con imagen opcional
  Future<void> agregarComida(Comida comida, File? imageFile) async {
    String imageUrl = comida.imagen;
    if (imageFile != null) {
      final ref = _storage.ref().child('comidas/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(imageFile);
      imageUrl = await ref.getDownloadURL();
    }

    await _db.collection('comidas').add({
      'nombre': comida.nombre,
      'descripcion': comida.descripcion,
      'tipo': comida.tipo,
      'precio': comida.precio,
      'imagen': imageUrl,
    });
  }

  // Actualizar comida existente
  Future<void> actualizarComida(Comida comida, File? newImage) async {
    String imageUrl = comida.imagen;
    if (newImage != null) {
      final ref = _storage.ref().child('comidas/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(newImage);
      imageUrl = await ref.getDownloadURL();
    }

    await _db.collection('comidas').doc(comida.id).update({
      'nombre': comida.nombre,
      'descripcion': comida.descripcion,
      'tipo': comida.tipo,
      'precio': comida.precio,
      'imagen': imageUrl,
    });
  }

  // Eliminar comida y su imagen
  Future<void> eliminarComida(String id, String? imageUrl) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      await _storage.refFromURL(imageUrl).delete();
    }
    await _db.collection('comidas').doc(id).delete();
  }
}

