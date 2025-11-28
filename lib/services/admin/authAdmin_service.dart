import 'package:firebase_auth/firebase_auth.dart';

class AuthAdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginAdmin(String email, String password) async {
    // Opcional: Validar que sea admin real
    if (!email.endsWith("@lacabanadmin.com")) {
      throw Exception("No tienes acceso de administrador");
    }

    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return cred.user;
  }
}
