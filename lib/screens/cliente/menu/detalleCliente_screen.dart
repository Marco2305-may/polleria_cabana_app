import 'package:flutter/material.dart';
import '../../../models/comida.dart';
import '../../../models/pedido_item.dart';
import '../../../services/cliente/carritoCliente_service.dart';
import '../../../widgets/custom_buttom.dart';

class DetalleClienteScreen extends StatefulWidget {
  final Comida comida;
  final String idUsuario;
  final CarritoClienteService carritoService;

  const DetalleClienteScreen({
    super.key,
    required this.comida,
    required this.idUsuario,
    required this.carritoService,
  });

  @override
  State<DetalleClienteScreen> createState() => _DetalleClienteScreenState();
}

class _DetalleClienteScreenState extends State<DetalleClienteScreen> {
  int cantidad = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Imagen grande
          Stack(
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: widget.comida.imagen.isNotEmpty
                    ? Image.network(widget.comida.imagen, fit: BoxFit.cover)
                    : Image.asset('assets/images/default_food.jpg', fit: BoxFit.cover),
              ),
              // Botón volver
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contenido
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comida.nombre,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.comida.descripcion,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Text(
                  'Precio: S/. ${widget.comida.precio.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Cantidad
                Row(
                  children: [
                    const Text('Cantidad:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        if (cantidad > 1) setState(() => cantidad--);
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$cantidad', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () {
                        if (cantidad < 5) setState(() => cantidad++);
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Mensaje solo si es plato principal
                widget.comida.tipo == 'plato principal'
                    ? const Text(
                  'Incluye ají, mayonesa, mostaza y ketchup.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                )
                    : const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Botón agregar al carrito
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomButton(
              text: 'Agregar al Carrito',
              onPressed: () {
                final pedidoItem = PedidoItem(
                  idComida: widget.comida.id,
                  nombre: widget.comida.nombre, // ⚡ aquí era el missing
                  cantidad: cantidad,
                  subtotal: widget.comida.precio * cantidad,
                );

                widget.carritoService.agregarAlCarrito(pedidoItem, widget.idUsuario);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.comida.nombre} x$cantidad agregado al carrito'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}










