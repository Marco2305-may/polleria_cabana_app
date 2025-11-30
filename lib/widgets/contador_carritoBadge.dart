import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/pedido_item.dart';
import '../screens/cliente/menu/carritoCliente_screen.dart';
import '../services/cliente/carritoCliente_service.dart';

class CartIconWithBadge extends StatelessWidget {
  final CarritoClienteService _carritoService;

  CartIconWithBadge({super.key, required CarritoClienteService carritoService})
      : _carritoService = carritoService;

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return ValueListenableBuilder<List<PedidoItem>>(
      valueListenable: _carritoService.itemsNotifier,
      builder: (context, carrito, _) {
        int totalItems = carrito.fold(0, (sum, item) => sum + item.cantidad);

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.brown),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarritoClienteScreen(
                      idUsuario: userId,
                    ),
                  ),
                );
              },
            ),
            if (totalItems > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$totalItems',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
