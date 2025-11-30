import 'package:flutter/material.dart';
import '../../../models/pedido_item.dart';
import '../../../services/cliente/pedidoCliente_service.dart';
import '../../../widgets/custom_buttom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mapaDireccion_screen.dart';

class PedidoFormScreen extends StatefulWidget {
  final String idUsuario;

  const PedidoFormScreen({super.key, required this.idUsuario});

  @override
  State<PedidoFormScreen> createState() => _PedidoFormScreenState();
}

class _PedidoFormScreenState extends State<PedidoFormScreen> {
  String direccionText = "";
  double? selectedLat;
  double? selectedLng;
  double totalPedido = 0;
  String metodoPago = "Efectivo";

  final PedidoClienteService _service = PedidoClienteService();
  List<Map<String, dynamic>> carritoItems = [];

  @override
  void initState() {
    super.initState();
    _cargarCarrito();
  }

  Future<void> _cargarCarrito() async {
    final carritoRef =
    FirebaseFirestore.instance.collection("carritos").doc(widget.idUsuario);
    final carritoDoc = await carritoRef.get();

    if (!carritoDoc.exists) {
      await carritoRef.set({'fechaCreacion': DateTime.now()});
      setState(() {
        totalPedido = 0;
        carritoItems = [];
      });
      return;
    }

    final itemsSnap = await carritoRef.collection("items").get();

    double total = 0;
    List<Map<String, dynamic>> items = [];

    for (var doc in itemsSnap.docs) {
      final data = doc.data();
      final idComida = data["idComida"];
      final cantidad = data["cantidad"] ?? 1;
      final subtotal = (data["subtotal"] ?? 0).toDouble();

      final comidaSnap =
      await FirebaseFirestore.instance.collection("comidas").doc(idComida).get();
      final nombreComida = comidaSnap.data()?["nombre"] ?? "Producto";

      total += subtotal;

      items.add({
        "idComida": idComida,
        "nombre": nombreComida,
        "cantidad": cantidad,
        "subtotal": subtotal,
      });
    }

    setState(() {
      totalPedido = total;
      carritoItems = items;
    });
  }

  Future<void> _crearPedido() async {
    if (direccionText.isEmpty || carritoItems.isEmpty || selectedLat == null || selectedLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Selecciona dirección y verifica el carrito")),
      );
      return;
    }

    try {
      final items = carritoItems
          .map((item) => PedidoItem(
        idComida: item['idComida'],
        nombre: item['nombre'],
        cantidad: item['cantidad'],
        subtotal: item['subtotal'],
      ))
          .toList();

      await _service.crearPedido(
        idUsuario: widget.idUsuario,
        direccion: direccionText,
        lat: selectedLat!,
        lng: selectedLng!,
        metodoPago: metodoPago,
        items: items,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pedido creado con éxito 🎉")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear pedido: $e")),
      );
    }
  }

  Widget _radioMetodo(String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: metodoPago,
          onChanged: (val) {
            if (val != null) setState(() => metodoPago = val);
          },
        ),
        Text(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Pedido")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: CustomButton(
                text: "Ponga su dirección de envío",
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MapaDireccionScreen(),
                    ),
                  );

                  if (result != null && result is DireccionSeleccionada) {
                    setState(() {
                      direccionText = result.direccion;
                      selectedLat = result.lat;
                      selectedLng = result.lng;
                    });
                  }
                },
              ),
            ),

            if (direccionText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Dirección seleccionada: $direccionText",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Productos en tu pedido:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  ...carritoItems.map((item) => ListTile(
                    title: Text(item['nombre']),
                    subtitle: Text('Cantidad: ${item['cantidad']}'),
                    trailing: Text(
                        'S/ ${(item['subtotal'] as double).toStringAsFixed(2)}'),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Método de pago:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _radioMetodo("Efectivo"),
                      const SizedBox(width: 10),
                      _radioMetodo("Yape / Plin"),
                      const SizedBox(width: 10),
                      _radioMetodo("POS"),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Total del pedido: S/ ${carritoItems.fold(0.0, (sum, item) => sum + (item['subtotal'] as double)).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: "Crear Pedido",
                onPressed: _crearPedido,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}












