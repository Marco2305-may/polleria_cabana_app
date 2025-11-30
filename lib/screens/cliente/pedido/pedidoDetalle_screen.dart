import 'package:flutter/material.dart';
import '../../../models/pedido.dart';

class PedidoDetalleScreen extends StatelessWidget {
  final Pedido pedido;

  const PedidoDetalleScreen({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Pedido")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pedido ID: ${pedido.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Estado: ${pedido.estado}"),
            Text("Dirección: ${pedido.direccion}"),
            Text("Total: S/ ${pedido.total.toStringAsFixed(2)}"),
            const SizedBox(height: 16),
            const Text("Productos:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: pedido.items.length,
                itemBuilder: (context, index) {
                  final item = pedido.items[index];
                  return ListTile(
                    title: Text(item.nombre),
                    subtitle: Text("Cantidad: ${item.cantidad}"),
                    trailing: Text("S/ ${item.subtotal.toStringAsFixed(2)}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
