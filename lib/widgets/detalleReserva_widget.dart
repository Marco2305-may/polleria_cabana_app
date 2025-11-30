import 'package:flutter/material.dart';
import '../../../models/reservacion.dart';

class ReservaDetalleScreen extends StatelessWidget {
  final Reservacion reserva;

  const ReservaDetalleScreen({super.key, required this.reserva});

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year} "
        "${fecha.hour.toString().padLeft(2, '0')}:"
        "${fecha.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "Detalle de reserva",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("📝 Detalle:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(reserva.detalle),
          const SizedBox(height: 10),

          Text("👥 Invitados:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text("${reserva.invitados} personas"),
          const SizedBox(height: 10),

          Text("📅 Fecha:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_formatearFecha(reserva.fechaHora)),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Cerrar"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
