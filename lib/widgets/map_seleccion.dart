import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaSeleccionWidget extends StatefulWidget {
  final LatLng initialPosition;
  final Function(LatLng) onLocationChanged;

  const MapaSeleccionWidget({
    super.key,
    required this.initialPosition,
    required this.onLocationChanged,
  });

  @override
  State<MapaSeleccionWidget> createState() => _MapaSeleccionWidgetState();
}

class _MapaSeleccionWidgetState extends State<MapaSeleccionWidget> {
  late LatLng selectedPosition;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    selectedPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: selectedPosition,
          zoom: 16,
        ),
        onMapCreated: (controller) => mapController = controller,
        markers: {
          Marker(
            markerId: const MarkerId("ubicacion"),
            position: selectedPosition,
            draggable: true,
            onDragEnd: (pos) {
              setState(() {
                selectedPosition = pos;
              });
              widget.onLocationChanged(pos);
            },
          ),
        },
        onTap: (pos) {
          setState(() {
            selectedPosition = pos;
          });
          widget.onLocationChanged(pos);
        },
      ),
    );
  }
}
