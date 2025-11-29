import 'package:flutter/material.dart';
import '../../../models/comida.dart';
import '../screens/cliente/menu/detalleCliente_screen.dart';

class FoodCard extends StatelessWidget {
  final Comida comida;
  final String idUsuario; // 🟢 Usuario actual para DetalleClienteScreen

  const FoodCard({super.key, required this.comida, required this.idUsuario});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navega a DetalleClienteScreen al tocar cualquier parte del card
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleClienteScreen(
              comida: comida,
              idUsuario: idUsuario,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Imagen con placeholder y manejo de errores
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                comida.imagen.isNotEmpty
                    ? comida.imagen
                    : 'https://via.placeholder.com/110',
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    width: 110,
                    height: 110,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return SizedBox(
                    width: 110,
                    height: 110,
                    child: Center(child: Icon(Icons.image_not_supported)),
                  );
                },
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comida.nombre,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      comida.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "S/. ${comida.precio.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



