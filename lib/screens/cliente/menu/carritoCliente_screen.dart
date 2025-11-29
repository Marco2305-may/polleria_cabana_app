import 'package:flutter/material.dart';
import '../../../models/carrito_item.dart';
import '../../../models/comida.dart';
import '../../../services/cliente/carritoCliente_service.dart';
import '../../../services/cliente/comidaCliente_service.dart';
import '../../../widgets/custom_buttom.dart';

class CarritoClienteScreen extends StatefulWidget {
  final String idUsuario;

  const CarritoClienteScreen({super.key, required this.idUsuario});

  @override
  State<CarritoClienteScreen> createState() => _CarritoClienteScreenState();
}

class _CarritoClienteScreenState extends State<CarritoClienteScreen> {
  final _carritoService = CarritoClienteService();
  final _comidaService = ComidaClienteService();

  List<Comida> _comidas = [];
  bool _cargandoComidas = true;

  @override
  void initState() {
    super.initState();
    _cargarComidas();
  }

  Future<void> _cargarComidas() async {
    final comidas = await _comidaService.obtenerComidas().first;
    setState(() {
      _comidas = comidas;
      _cargandoComidas = false;
    });
  }

  Comida? buscarComida(String id) {
    try {
      return _comidas.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  double getTotal(List<CarritoItem> items) {
    return items.fold(0, (sum, item) => sum + item.subtotal);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoComidas) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: Colors.brown[700],
      ),
      body: StreamBuilder<List<CarritoItem>>(
        stream: _carritoService.obtenerCarrito(widget.idUsuario),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final carritoItems = snapshot.data!;
          if (carritoItems.isEmpty) {
            return const Center(child: Text('Carrito vacío'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: carritoItems.length,
                  itemBuilder: (context, index) {
                    final item = carritoItems[index];
                    final comida = buscarComida(item.idComida);

                    if (comida == null) {
                      return const ListTile(
                        title: Text("Producto no encontrado"),
                      );
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                comida.imagen,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comida.nombre,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Cantidad: ${item.cantidad}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Subtotal: S/. ${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔥 BOTÓN ELIMINAR SOLO
                            IconButton(
                              onPressed: () {
                                _carritoService.eliminarItem(
                                  widget.idUsuario,
                                  item.id,
                                );
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Footer total + pedido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: S/. ${getTotal(carritoItems).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'Realizar pedido',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Pedido realizado (simulación)')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}





