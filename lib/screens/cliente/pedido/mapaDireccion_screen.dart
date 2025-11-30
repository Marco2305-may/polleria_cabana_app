import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../widgets/custom_buttom.dart';

class DireccionSeleccionada {
  final String direccion;
  final double lat;
  final double lng;

  DireccionSeleccionada({
    required this.direccion,
    required this.lat,
    required this.lng,
  });
}

class MapaDireccionScreen extends StatefulWidget {
  const MapaDireccionScreen({super.key});

  @override
  State<MapaDireccionScreen> createState() => _MapaDireccionScreenState();
}

class _MapaDireccionScreenState extends State<MapaDireccionScreen> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;
  String direccionText = "";

  final TextEditingController _searchController = TextEditingController();

  Future<void> _buscarDireccion() async {
    if (_searchController.text.isEmpty) return;
    try {
      final locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(loc.latitude, loc.longitude), 16),
        );
        setState(() {
          selectedLocation = LatLng(loc.latitude, loc.longitude);
          direccionText = _searchController.text;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo localizar la dirección")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona tu dirección")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-12.0464, -77.0428),
              zoom: 14,
            ),
            onMapCreated: (controller) => mapController = controller,
            onTap: (pos) {
              setState(() {
                selectedLocation = pos;
              });
              _getDireccion(pos);
            },
            markers: selectedLocation != null
                ? {Marker(markerId: const MarkerId("ubicacion"), position: selectedLocation!)}
                : {},
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Buscar dirección...",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscarDireccion,
                )
              ],
            ),
          ),
          if (selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: CustomButton(
                text: "Dirección seleccionada: $direccionText",
                onPressed: () {
                  Navigator.pop(
                    context,
                    DireccionSeleccionada(
                      direccion: direccionText,
                      lat: selectedLocation!.latitude,
                      lng: selectedLocation!.longitude,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _getDireccion(LatLng pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          direccionText =
          "${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}";
        });
      }
    } catch (e) {
      setState(() {
        direccionText = "Lat: ${pos.latitude.toStringAsFixed(6)}, Lng: ${pos.longitude.toStringAsFixed(6)}";
      });
    }
  }
}

