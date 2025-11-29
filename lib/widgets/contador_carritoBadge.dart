import 'package:firebase_auth/firebase_auth.dart';

import '../screens/cliente/menu/carritoCliente_screen.dart';
import '../services/cliente/carritoCliente_service.dart';
import 'package:flutter/material.dart';

class CartIconWithBadge extends StatelessWidget {
  final _carritoService = CarritoClienteService();

  CartIconWithBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return StreamBuilder(
      stream: _carritoService.obtenerCarrito(userId),
      builder: (context, snapshot) {
        int totalItems = 0;

        if (snapshot.hasData) {
          final carrito = snapshot.data!;
          // Sumamos todas las cantidades
          totalItems = carrito.fold(0, (sum, item) => sum + item.cantidad);
        }

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.brown),
              onPressed: () {
                // Navegamos a pantalla de carrito
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
            // Badge
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