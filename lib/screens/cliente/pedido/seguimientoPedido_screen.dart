import 'package:flutter/material.dart';
import '../../../models/pedido.dart';
import '../../../services/cliente/pedidoCliente_service.dart';
import 'pedidoDetalle_screen.dart';
import 'pedidoMapa_screen.dart';

class SeguimientoPedidosScreen extends StatefulWidget {
  final String idUsuario;

  const SeguimientoPedidosScreen({super.key, required this.idUsuario});

  @override
  State<SeguimientoPedidosScreen> createState() => _SeguimientoPedidosScreenState();
}

class _SeguimientoPedidosScreenState extends State<SeguimientoPedidosScreen> {
  final PedidoClienteService _service = PedidoClienteService();
  List<Pedido> pedidos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    setState(() => isLoading = true);
    try {
      final lista = await _service.obtenerPedidos(widget.idUsuario);
      setState(() {
        pedidos = lista;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar pedidos: $e")),
      );
    }
  }

  Future<void> _eliminarPedido(String idPedido) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Deseas eliminar este pedido?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.eliminarPedido(idPedido);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pedido eliminado")),
        );
        _cargarPedidos();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (pedidos.isEmpty) {
      return const Center(child: Text("No tienes pedidos aún"));
    }

    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        final pedido = pedidos[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Texto "Pedido N: Estado"
                Expanded(
                  child: Text(
                    "Pedido ${index + 1}: ${pedido.estado}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                // Iconos de acción
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart),
                      color: Colors.brown,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PedidoDetalleScreen(pedido: pedido),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on),
                      color: Colors.brown,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PedidoMapaScreen(pedido: pedido),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      color: Colors.red,
                      onPressed: () => _eliminarPedido(pedido.id),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


