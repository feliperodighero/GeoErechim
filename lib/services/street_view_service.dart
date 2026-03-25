import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_google_street_view/flutter_google_street_view.dart'
    as streetview;
import 'package:geoerechim/utils/generate_random_cordinates.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StreetViewService {
  /// Valida se existe Street View na coordenada
  static Future<bool> hasStreetView(streetview.LatLng candidate) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    final url =
        "https://maps.googleapis.com/maps/api/streetview/metadata?location=${candidate.latitude},${candidate.longitude}&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "OK") {
          return true;
        } else {
          print("Street View API Error: ${data["status"]} - ${data["error_message"] ?? ''}");
          if (data["status"] == "REQUEST_DENIED" || data["status"] == "OVER_QUERY_LIMIT") {
            throw Exception("Google API Error: ${data["status"]}");
          }
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in hasStreetView: $e");
      rethrow;
    }
    return false;
  }

  /// Gera coordenada até encontrar uma com Street View
  static Future<streetview.LatLng> generateValidCoordinate() async {
    int attempts = 0;
    while (attempts < 50) {
      attempts++;
      final candidate = generateRandomCoordinate();
      try {
        final valid = await hasStreetView(candidate);
        if (valid) return candidate;
      } catch (e) {
        print("Critical error while checking Street View: $e");
        break; // Stop the infinite loop
      }
      
      // Pequeno delay para não travar a thread principal caso muitas requisições falhem seguidas
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    // Fallback: se não achar em 50 tentativas ou der erro, retorna uma coordenada default conhecida em Erechim
    print("Could not find Street View after 50 attempts or an error occurred. Returning default fallback.");
    return streetview.LatLng(-27.6338, -52.2740); // Centro de Erechim (Praça da Bandeira)
  }
}
