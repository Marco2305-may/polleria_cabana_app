import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/pedido.dart';
import '../../../services/admin/pedidosAdmin_service.dart';


class PedidoScreen extends StatelessWidget {
  const PedidoScreen({super.key});

  Future<String> _getNombreUsuario(String idUsuario) async {
    final doc = await FirebaseFirestore.instance.collection('usuarios').doc(idUsuario).get();
    if (doc.exists) {
      return doc.data()?['nombre'] ?? "Usuario";
    }
    return "Usuario";
  }

  @override
  Widget build(BuildContext context) {
    final service = PedidoService();

    return StreamBuilder<List<Pedido>>(
      stream: service.getPedidos(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final pedidos = snapshot.data!;

        return ListView.builder(
          itemCount: pedidos.length,
          itemBuilder: (context, index) {
            final pedido = pedidos[index];
            return FutureBuilder<String>(
              future: _getNombreUsuario(pedido.idUsuario),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData) return const ListTile(title: Text("Cargando..."));
                final nombreUsuario = userSnapshot.data!;
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("Pedido de $nombreUsuario"),
                    subtitle: Text("Total: S/. ${pedido.total}"),
                    trailing: DropdownButton<String>(
                      value: pedido.estado,
                      items: ['Pendiente', 'Enviado', 'Entregado']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (nuevoEstado) {
                        if (nuevoEstado != null) {
                          service.actualizarEstado(pedido.id, nuevoEstado);
                        }
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

