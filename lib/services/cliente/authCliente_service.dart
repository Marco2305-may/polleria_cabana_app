// services/cliente/authCliente_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthClienteService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Login normal
  Future<User?> loginCliente(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return cred.user;
  }

  // Registro normal
  Future<User?> registrarCliente(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

    // Crear documento en Firestore
    await _crearPerfilFirestore(cred.user!);

    return cred.user;
  }

  // Login con Google
  Future<User?> loginWithGoogle() async {
    try {
      // Desconectamos sesión previa
      try { await _googleSignIn.signOut(); } catch (_) {}

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("GOOGLE SIGN-IN: usuario canceló");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final user = userCred.user;
      print("GOOGLE SIGN-IN OK: user=${user?.uid}");

      // CREAR PERFIL FIRESTORE si no existe
      await _crearPerfilFirestore(user!);

      return user;
    } catch (e, st) {
      print("ERROR GOOGLE AUTH → $e");
      print(st);
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
    try { await _googleSignIn.disconnect(); } catch (_) {}
  }

  // Función privada para crear perfil Firestore
  Future<void> _crearPerfilFirestore(User user) async {
    final userDoc = await _db.collection("usuarios").doc(user.uid).get();
    if (!userDoc.exists) {
      await _db.collection("usuarios").doc(user.uid).set({
        "nombre": user.displayName ?? "Usuario",
        "correo": user.email ?? "",
        "telefono": "",
      });
      print("Firestore: perfil creado para ${user.uid}");
    }
  }
}



