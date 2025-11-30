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
        title: const Text("Cancelar reserva"),
        content: const Text("¿Deseas cancelar esta reserva?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Sí"),
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
      appBar: AppBar(title: const Text("Reservaciones")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : reservas.isEmpty
          ? const Center(child: Text("No tienes reservaciones"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reservas.length,
        itemBuilder: (_, i) {
          final r = reservas[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            child: ListTile(
              title: Text(
                r.detalle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Invitados: ${r.invitados}\n"
                    "Fecha: ${_formatearFecha(r.fechaHora)}",
              ),

              // ⬇⬇⬇ AQUÍ ESTABA EL ERROR — YA CORREGIDO
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.info, color: Colors.blue),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => ReservaDetalleScreen(reserva: r),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _cancelarReserva(r.id),
                  ),
                ],
              ),
              // ⬆⬆⬆ FIN SOLUCIÓN
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  CrearReservaScreen(idUsuario: widget.idUsuario),
            ),
          );
          _cargarReservas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


