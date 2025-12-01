import 'package:flutter/material.dart';
import '../../../services/cliente/reservacionCliente_service.dart';
import '../../../models/reservacion.dart';
import '../../../widgets/detalleReserva_widget.dart';
import 'crearReserva_screen.dart';

class ReservasScreen extends StatefulWidget {
  final String idUsuario;

  const ReservasScreen({super.key, required this.idUsuario});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  final ReservacionService service = ReservacionService();
  List<Reservacion> reservas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _cargarReservas();
  }

  Future<void> _cargarReservas() async {
    try {
      reservas = await service.obtenerReservas(widget.idUsuario);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error cargando reservas: $e")),
        );
      }
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> _cancelarReserva(String id) async {
    final confirmar = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFF3E0),
        title: const Text("Cancelar reserva",
            style: TextStyle(color: Color(0xFF5D3A1A))),
        content: const Text("¿Deseas cancelar esta reserva?",
            style: TextStyle(color: Colors.brown)),
        actions: [
          TextButton(
            child: const Text("No", style: TextStyle(color: Colors.brown)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("Sí", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await service.eliminarReservacion(id);
        await _cargarReservas();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reserva eliminada")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al eliminar: $e")),
          );
        }
      }
    }
  }

  String _formatearFecha(DateTime fecha) {
    return "${fecha.day}/${fecha.month}/${fecha.year} • "
        "${fecha.hour.toString().padLeft(2, '0')}:"
        "${fecha.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD180),
        title: const Text(
          "🍽 Tus Reservaciones",
          style: TextStyle(color: Color(0xFF5D3A1A), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : reservas.isEmpty
          ? const Center(
        child: Text(
          "No tienes reservaciones 😢",
          style: TextStyle(
            color: Colors.brown,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservas.length,
        itemBuilder: (_, i) {
          final r = reservas[i];

          return Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: const Color(0xFFFFE0B2),
            margin: const EdgeInsets.only(bottom: 18),

            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                r.detalle,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D3A1A),
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                "👥 Invitados: ${r.invitados}\n📅 Fecha: ${_formatearFecha(r.fechaHora)}",
                style: const TextStyle(
                  color: Colors.brown,
                  height: 1.4,
                ),
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info,
                        color: Colors.blue, size: 28),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            ReservaDetalleScreen(reserva: r),
                      );
                    },
                  ),
                  IconButton(
                    icon:
                    const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _cancelarReserva(r.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,   // FAB blanco 🤍
        elevation: 6,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CrearReservaScreen(idUsuario: widget.idUsuario),
            ),
          );
          _cargarReservas();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,            // Icono negro
          size: 32,
        ),
      ),
    );
  }
}


