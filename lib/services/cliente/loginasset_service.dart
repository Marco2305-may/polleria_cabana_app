import 'package:firebase_storage/firebase_storage.dart';

class LoginAssetsService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getLoginImage() async {
    try {
      final ref = _storage.ref().child("login/Pollo_login.png");
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print("Error al cargar imagen de login: $e");
      return "";  // regresa vacío si falla
    }
  }
}
