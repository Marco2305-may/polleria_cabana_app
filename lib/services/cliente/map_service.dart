import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../utils/keys.dart';

class MapService {
  final String apiKey = kGoogleApiKey ; // Pon tu API Key aquí

  // Obtener ruta entre origen y destino
  Future<Map<String, dynamic>> obtenerRuta({
    required LatLng origen,
    required LatLng destino,
  }) async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origen.latitude},${origen.longitude}&destination=${destino.latitude},${destino.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] != 'OK') {
      throw Exception("Error obteniendo ruta: ${data['status']}");
    }

    final route = data['routes'][0];
    final leg = route['legs'][0];

    // Tiempo estimado en minutos
    final tiempo = leg['duration']['value'] ~/ 60;

    // Extraer polyline codificado
    final polylinePoints = _decodePolyline(route['overview_polyline']['points']);

    return {
      'polyline': polylinePoints,
      'tiempo': tiempo,
    };
  }

  // Decodificar polyline de Google
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return poly;
  }
}
