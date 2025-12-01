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
        title: const Text("Eliminar Pedido"),
        content: const Text("¿Estás seguro que deseas eliminar este pedido?"),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
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

  Widget _estadoChip(String estado) {
    Color color;
    switch (estado) {
      case "pendiente":
        color = Colors.orange;
        break;
      case "preparando":
        color = Colors.blue;
        break;
      case "en camino":
        color = Colors.green;
        break;
      case "entregado":
        color = Colors.brown;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        estado.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3CD), // Fondo pollito suave
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text(
          "Mis Pedidos",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pedidos.isEmpty
          ? const Center(
        child: Text(
          "🍗 No tienes pedidos aún",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.brown,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];

          return Card(
            elevation: 6,
            shadowColor: Colors.brown.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabecera pedido
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pedido #${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.brown,
                        ),
                      ),
                      _estadoChip(pedido.estado),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Botones
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PedidoDetalleScreen(pedido: pedido),
                            ),
                          );
                        },
                        icon: const Icon(Icons.receipt_long),
                        label: const Text("Detalles"),
                      ),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PedidoMapaScreen(pedido: pedido),
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text("Mapa"),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete,
                            color: Colors.red),
                        onPressed: () => _eliminarPedido(pedido.id),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




