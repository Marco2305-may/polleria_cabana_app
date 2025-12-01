import 'package:cloud_firestore/cloud_firestore.dart';

class RoleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String?> obtenerRol(String uid) async {
    final doc = await _db.collection("usuarios").doc(uid).get();
    if (!doc.exists) return null;
    return doc["rol"];
  }
}
