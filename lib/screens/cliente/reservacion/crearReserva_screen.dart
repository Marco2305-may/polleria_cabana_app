import 'package:flutter/material.dart';
import '../../../services/cliente/reservacionCliente_service.dart';


class CrearReservaScreen extends StatefulWidget {
  final String idUsuario;

  const CrearReservaScreen({super.key, required this.idUsuario});

  @override
  State<CrearReservaScreen> createState() => _CrearReservaScreenState();
}

class _CrearReservaScreenState extends State<CrearReservaScreen> {
  final detalleCtrl = TextEditingController();
  final invitadosCtrl = TextEditingController();
  DateTime? fechaHora;

  final ReservacionService service = ReservacionService();

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (fecha == null) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (hora == null) return;

    setState(() {
      fechaHora = DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute);
    });
  }

  Future<void> _guardar() async {
    if (detalleCtrl.text.isEmpty ||
        invitadosCtrl.text.isEmpty ||
        fechaHora == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    await service.crearReservacion(
      detalle: detalleCtrl.text,
      invitados: int.parse(invitadosCtrl.text),
      fechaHora: fechaHora!,
      idUsuario: widget.idUsuario,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Reserva")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: detalleCtrl,
              decoration: const InputDecoration(labelText: "Detalle de la reserva"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: invitadosCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Número de invitados"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    fechaHora == null
                        ? "Selecciona fecha y hora"
                        : "Fecha: ${fechaHora.toString()}",
                  ),
                ),
                ElevatedButton(
                  onPressed: _seleccionarFecha,
                  child: const Text("Elegir"),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _guardar,
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}

