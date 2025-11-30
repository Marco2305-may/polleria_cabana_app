import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/pedido.dart';
import '../../../services/cliente/map_service.dart';

class PedidoMapaScreen extends StatefulWidget {
  final Pedido pedido;

  const PedidoMapaScreen({super.key, required this.pedido});

  @override
  State<PedidoMapaScreen> createState() => _PedidoMapaScreenState();
}

class _PedidoMapaScreenState extends State<PedidoMapaScreen> {
  GoogleMapController? mapController;
  final MapService _mapService = MapService();

  final LatLng polleriaLocation = const LatLng(-12.02454468047627, -76.90101747010524);
  late LatLng clienteLocation;

  List<LatLng> ruta = [];
  int tiempoEstimado = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    clienteLocation = LatLng(widget.pedido.lat, widget.pedido.lng);
    _cargarRuta();
  }

  Future<void> _cargarRuta() async {
    try {
      final data = await _mapService.obtenerRuta(
        origen: polleriaLocation,
        destino: clienteLocation,
      );
      setState(() {
        ruta = data['polyline'];
        tiempoEstimado = data['tiempo'];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error cargando ruta: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final polyline = Polyline(
      polylineId: const PolylineId("ruta"),
      points: ruta,
      color: Colors.blue,
      width: 5,
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Seguimiento del Pedido")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: clienteLocation,
                zoom: 14,
              ),
              markers: {
                Marker(markerId: const MarkerId("polleria"), position: polleriaLocation, infoWindow: const InfoWindow(title: "Pollería")),
                Marker(markerId: const MarkerId("cliente"), position: clienteLocation, infoWindow: const InfoWindow(title: "Tu dirección")),
              },
              polylines: {polyline},
              onMapCreated: (controller) => mapController = controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Tiempo estimado de entrega: $tiempoEstimado min",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
