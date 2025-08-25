int calculateStars(double distance) {
  if (distance <= 100) return 5;
  if (distance <= 500) return 4;
  if (distance <= 1000) return 3;
  if (distance <= 2000) return 2;
  if (distance <= 5000) return 1;
  return 0;
}