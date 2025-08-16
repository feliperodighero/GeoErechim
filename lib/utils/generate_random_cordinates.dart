import 'dart:math';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';

LatLng generateRandomCoordinate() {
  final random = Random();

  double minLat = -27.6670;
  double maxLat = -27.5890;
  double minLng = -52.3140;
  double maxLng = -52.2400;

  double lat = minLat + random.nextDouble() * (maxLat - minLat);
  double lng = minLng + random.nextDouble() * (maxLng - minLng);

  return LatLng(lat, lng);
}
