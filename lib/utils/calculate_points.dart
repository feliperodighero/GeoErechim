int calculatePoints(double distance) {
  const maxPoints = 5000;
  const maxDistance = 5000; // meters

  int points = ((1 - (distance / maxDistance)) * maxPoints).clamp(0, maxPoints).toInt();
  return points;
}
