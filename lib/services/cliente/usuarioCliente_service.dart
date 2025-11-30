import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/usuario.dart';

class UsuarioClienteService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// OBTENER DATOS DEL USUARIO
  Future<Usuario?> obtenerUsuario(String id) async {
    final doc = await _db.collection("usuarios").doc(id).get();
    if (!doc.exists) return null;
    return Usuario.fromMap(doc.id, doc.data()!);
  }

  /// ACTUALIZAR PERFIL (nombre, telefono)
  Future<void> actualizarUsuario(String id, Map<String, dynamic> data) async {
    await _db.collection("usuarios").doc(id).update(data);
  }

  /// VERIFICA CONTRASEÑA ACTUAL
  Future<bool> verificarCorreo(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// CAMBIAR CONTRASEÑA REAL
  Future<void> cambiarPassword(String nueva) async {
    await _auth.currentUser!.updatePassword(nueva);
  }
}
