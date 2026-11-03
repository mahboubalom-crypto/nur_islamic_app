import 'dart:math' as math;

// ==========================================================
// কাবার স্থানাঙ্ক (স্থির)
// ==========================================================
const double _kaabaLat = 21.4225;
const double _kaabaLng = 39.8262;

class QiblaData {
  final double qiblaBearing; // উত্তর দিক থেকে কত ডিগ্রি
  final double distanceKm;

  const QiblaData({required this.qiblaBearing, required this.distanceKm});
}

double _toRadians(double deg) => deg * math.pi / 180;
double _toDegrees(double rad) => rad * 180 / math.pi;

// ---- Great-circle bearing ফর্মুলা দিয়ে কিবলার দিক বের করা ----
QiblaData calculateQibla(double lat, double lng) {
  final lat1 = _toRadians(lat);
  final lat2 = _toRadians(_kaabaLat);
  final deltaLng = _toRadians(_kaabaLng - lng);

  final y = math.sin(deltaLng) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(deltaLng);

  double bearing = _toDegrees(math.atan2(y, x));
  bearing = (bearing + 360) % 360;

  // ---- Haversine ফর্মুলা দিয়ে দূরত্ব (কিলোমিটার) ----
  const earthRadiusKm = 6371.0;
  final dLat = _toRadians(_kaabaLat - lat);
  final dLng = _toRadians(_kaabaLng - lng);
  final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(lat1) * math.cos(lat2) * math.sin(dLng / 2) * math.sin(dLng / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  final distance = earthRadiusKm * c;

  return QiblaData(
    qiblaBearing: double.parse(bearing.toStringAsFixed(1)),
    distanceKm: double.parse(distance.toStringAsFixed(0)),
  );
}
