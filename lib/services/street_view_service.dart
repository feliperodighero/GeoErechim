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

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["status"] == "OK";
    }
    return false;
  }

  /// Gera coordenada até encontrar uma com Street View
  static Future<streetview.LatLng> generateValidCoordinate() async {
    while (true) {
      final candidate = generateRandomCoordinate();
      final valid = await hasStreetView(candidate);
      if (valid) return candidate;
    }
  }
}
