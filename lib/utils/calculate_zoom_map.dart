double calculateZoom(double distance) {
  if (distance <= 100) return 17.0;
  if (distance <= 500) return 15.0;
  if (distance <= 1000) return 14.0;
  if (distance <= 2000) return 13.0;
  if (distance <= 5000) return 12.0;
  return 11.0;
}
