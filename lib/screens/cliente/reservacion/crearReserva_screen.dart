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
      backgroundColor: const Color(0xFFFFF7E9), // Color pollería
      appBar: AppBar(
        backgroundColor: const Color(0xFFB71C1C), // Rojo pollería 🔥
        elevation: 0,
        title: const Text(
          "Crear Reserva",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título
            const Text(
              "Detalles de la Reserva",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 15),

            // Campo Detalle
            TextField(
              controller: detalleCtrl,
              decoration: InputDecoration(
                labelText: "Detalle de la reserva",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.description, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Campo Invitados
            TextField(
              controller: invitadosCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Número de invitados",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.group, color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Fecha y Hora
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fechaHora == null
                          ? "Selecciona fecha y hora"
                          : "Fecha: ${fechaHora.toString().substring(0, 16)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.brown,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _seleccionarFecha,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text("Elegir"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8D6E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const Spacer(),

            // Botón Guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB71C1C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Guardar Reserva",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

