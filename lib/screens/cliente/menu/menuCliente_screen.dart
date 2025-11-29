import 'package:flutter/material.dart';
import '../../../models/comida.dart';
import '../../../services/cliente/comidaCliente_service.dart';
import '../../../widgets/contador_carritoBadge.dart';
import '../../../widgets/food_card.dart';

class MenuClienteScreen extends StatelessWidget {
  final String idUsuario;

  MenuClienteScreen({super.key, required this.idUsuario});

  final _service = ComidaClienteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Menú",
          style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          CartIconWithBadge(),
        ],
      ),
      body: StreamBuilder<List<Comida>>(
        stream: _service.obtenerComidas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No hay comidas disponibles 😢"),
            );
          }

          final comidas = snapshot.data!;

          return ListView.builder(
            itemCount: comidas.length,
            itemBuilder: (context, index) {
              return FoodCard(
                comida: comidas[index],
                idUsuario: idUsuario, // 👈 AHORA SÍ SE ENVÍA
              );
            },
          );
        },
      ),
    );
  }
}

