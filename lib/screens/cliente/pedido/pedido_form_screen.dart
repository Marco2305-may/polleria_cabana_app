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

      final comidaSnap = await FirebaseFirestore.instance
          .collection("comidas")
          .doc(idComida)
          .get();
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
    if (direccionText.isEmpty ||
        carritoItems.isEmpty ||
        selectedLat == null ||
        selectedLng == null) {
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

  Widget _radioMetodo(String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: metodoPago,
            onChanged: (val) {
              if (val != null) setState(() => metodoPago = val);
            },
          ),
          Icon(icon, color: Colors.brown),
          const SizedBox(width: 4),
          Text(value, style: const TextStyle(color: Color(0xFF5D3A1A))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD180),
        title: const Text(
          "🛵 Crear Pedido",
          style: TextStyle(
              color: Color(0xFF5D3A1A), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // DIRECCIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: "📍 Seleccionar dirección de envío",
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
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE0B2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.home, color: Colors.brown),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          direccionText,
                          style: const TextStyle(
                              color: Color(0xFF5D3A1A),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // ITEMS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("🍗 Productos:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D3A1A))),
                  const SizedBox(height: 12),

                  ...carritoItems.map(
                        (item) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE0B2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        title: Text(item['nombre'],
                            style: const TextStyle(
                                color: Color(0xFF5D3A1A),
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "Cantidad: ${item['cantidad']}",
                          style: const TextStyle(color: Colors.brown),
                        ),
                        trailing: Text(
                          "S/ ${(item['subtotal']).toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // MÉTODO DE PAGO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("💳 Método de pago:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D3A1A))),
                  const SizedBox(height: 12),

                  Wrap(
                    children: [
                      _radioMetodo("Efectivo", Icons.attach_money),
                      _radioMetodo("Yape / Plin", Icons.phone_android),
                      _radioMetodo("POS", Icons.payment),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // TOTAL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD180),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  "TOTAL: S/ ${carritoItems.fold(0.0, (sum, i) => sum + (i['subtotal'] as double)).toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 22,
                      color: Color(0xFF5D3A1A),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomButton(
                text: "🚀 Crear Pedido",
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













