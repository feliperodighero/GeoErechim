import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

double calculateDistance(LatLng start, LatLng end) {
  const earthRadius = 6371000; // meters
  double dLat = _degreesToRadians(end.latitude - start.latitude);
  double dLng = _degreesToRadians(end.longitude - start.longitude);

  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_degreesToRadians(start.latitude)) *
          cos(_degreesToRadians(end.latitude)) *
          sin(dLng / 2) *
          sin(dLng / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
