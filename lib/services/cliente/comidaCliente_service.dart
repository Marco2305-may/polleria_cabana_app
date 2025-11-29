import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/comida.dart';

class ComidaClienteService {
  final _db = FirebaseFirestore.instance;

  Stream<List<Comida>> obtenerComidas() {
    return _db.collection('comidas').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return Comida.fromMap(doc.id, doc.data());
        }).toList();
      },
    );
  }
}
