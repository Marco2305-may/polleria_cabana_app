import 'package:flutter/material.dart';
import '../../../models/reservacion.dart';
import '../../../services/admin/reservasAdmin_service.dart';


class ReservasAdminScreen extends StatefulWidget {
  const ReservasAdminScreen({super.key});

  @override
  State<ReservasAdminScreen> createState() => _ReservasAdminScreenState();
}

class _ReservasAdminScreenState extends State<ReservasAdminScreen> {
  final _service = ReservasAdminService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: StreamBuilder<List<Reservacion>>(
        stream: _service.obtenerReservas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reservas = snapshot.data!;
          if (reservas.isEmpty) {
            return const Center(child: Text("No hay reservas aún"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reservas.length,
            itemBuilder: (context, i) {
              final r = reservas[i];

              return FutureBuilder(
                future: _service.obtenerNombreUsuario(r.idUsuario),
                builder: (context, snap) {
                  final nombre = snap.data ?? "Cargando...";

                  return Card(
                    elevation: 4,
                    shadowColor: Colors.brown.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: const Icon(Icons.event, size: 36, color: Colors.brown),
                      title: Text(
                        nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            "📅 ${r.fechaHora.day}/${r.fechaHora.month}/${r.fechaHora.year}  "
                                "⏰ ${r.fechaHora.hour}:${r.fechaHora.minute.toString().padLeft(2, '0')}",
                          ),
                          Text("👥 Invitados: ${r.invitados}"),
                          Text("📝 ${r.detalle}"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
