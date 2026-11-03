// ==========================================================
// CityLocation Model
// ==========================================================
class CityLocation {
  final String nameBangla;
  final String nameEnglish;
  final double lat;
  final double lng;
  final String? division;
  final String country;
  final String? address;

  const CityLocation({
    required this.nameBangla,
    required this.nameEnglish,
    required this.lat,
    required this.lng,
    this.division,
    this.country = 'Bangladesh',
    this.address,
  });

  // ==========================================================
  // SharedPreferences-এর জন্য
  // ==========================================================
  Map<String, dynamic> toJson() => {
        'nameBangla': nameBangla,
        'nameEnglish': nameEnglish,
        'lat': lat,
        'lng': lng,
        'division': division,
        'country': country,
        'address': address,
      };

  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      nameBangla: json['nameBangla'] as String,
      nameEnglish: json['nameEnglish'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      division: json['division'] as String?,
      country: json['country'] as String? ?? 'Bangladesh',
      address: json['address'] as String?,
    );
  }
}

// ==========================================================
// বাংলাদেশের শহর
// ==========================================================
const List<CityLocation> bangladeshCities = [
  CityLocation(
    nameBangla: 'ঢাকা',
    nameEnglish: 'Dhaka',
    lat: 23.8103,
    lng: 90.4125,
    division: 'Dhaka',
  ),
  CityLocation(
    nameBangla: 'চট্টগ্রাম',
    nameEnglish: 'Chattogram',
    lat: 22.3569,
    lng: 91.7832,
    division: 'Chattogram',
  ),
  CityLocation(
    nameBangla: 'রাজশাহী',
    nameEnglish: 'Rajshahi',
    lat: 24.3745,
    lng: 88.6042,
    division: 'Rajshahi',
  ),
  CityLocation(
    nameBangla: 'খুলনা',
    nameEnglish: 'Khulna',
    lat: 22.8456,
    lng: 89.5403,
    division: 'Khulna',
  ),
  CityLocation(
    nameBangla: 'সিলেট',
    nameEnglish: 'Sylhet',
    lat: 24.8949,
    lng: 91.8687,
    division: 'Sylhet',
  ),
  CityLocation(
    nameBangla: 'বরিশাল',
    nameEnglish: 'Barishal',
    lat: 22.701,
    lng: 90.3535,
    division: 'Barishal',
  ),
  CityLocation(
    nameBangla: 'রংপুর',
    nameEnglish: 'Rangpur',
    lat: 25.7439,
    lng: 89.2752,
    division: 'Rangpur',
  ),
  CityLocation(
    nameBangla: 'ময়মনসিংহ',
    nameEnglish: 'Mymensingh',
    lat: 24.7471,
    lng: 90.4203,
    division: 'Mymensingh',
  ),
  CityLocation(
    nameBangla: 'কুমিল্লা',
    nameEnglish: 'Cumilla',
    lat: 23.4607,
    lng: 91.1809,
    division: 'Chattogram',
  ),
  CityLocation(
    nameBangla: 'বগুড়া',
    nameEnglish: 'Bogra',
    lat: 24.8481,
    lng: 89.373,
    division: 'Rajshahi',
  ),
  CityLocation(
    nameBangla: 'কক্সবাজার',
    nameEnglish: "Cox's Bazar",
    lat: 21.4272,
    lng: 92.0058,
    division: 'Chattogram',
  ),
  CityLocation(
    nameBangla: 'নোয়াখালী',
    nameEnglish: 'Noakhali',
    lat: 22.8696,
    lng: 91.0993,
    division: 'Chattogram',
  ),
  CityLocation(
    nameBangla: 'পাবনা',
    nameEnglish: 'Pabna',
    lat: 24.012,
    lng: 89.2435,
    division: 'Rajshahi',
  ),
  CityLocation(
    nameBangla: 'দিনাজপুর',
    nameEnglish: 'Dinajpur',
    lat: 25.6217,
    lng: 88.6354,
    division: 'Rangpur',
  ),
];

// ==========================================================
// বিশ্বের কিছু শহর
// ==========================================================
const List<CityLocation> worldCities = [
  CityLocation(
    nameBangla: 'রোম',
    nameEnglish: 'Rome',
    lat: 41.9028,
    lng: 12.4964,
    country: 'Italy',
  ),
  CityLocation(
    nameBangla: 'মিলান',
    nameEnglish: 'Milan',
    lat: 45.4642,
    lng: 9.19,
    country: 'Italy',
  ),
  CityLocation(
    nameBangla: 'মক্কা',
    nameEnglish: 'Makkah',
    lat: 21.4225,
    lng: 39.8262,
    country: 'Saudi Arabia',
  ),
  CityLocation(
    nameBangla: 'মদীনা',
    nameEnglish: 'Madinah',
    lat: 24.5247,
    lng: 39.5692,
    country: 'Saudi Arabia',
  ),
  CityLocation(
    nameBangla: 'লন্ডন',
    nameEnglish: 'London',
    lat: 51.5074,
    lng: -0.1278,
    country: 'United Kingdom',
  ),
  CityLocation(
    nameBangla: 'নিউ ইয়র্ক',
    nameEnglish: 'New York',
    lat: 40.7128,
    lng: -74.006,
    country: 'United States',
  ),
  CityLocation(
    nameBangla: 'রিয়াদ',
    nameEnglish: 'Riyadh',
    lat: 24.7136,
    lng: 46.6753,
    country: 'Saudi Arabia',
  ),
  CityLocation(
    nameBangla: 'দুবাই',
    nameEnglish: 'Dubai',
    lat: 25.2048,
    lng: 55.2708,
    country: 'United Arab Emirates',
  ),
  CityLocation(
    nameBangla: 'কুয়ালালামপুর',
    nameEnglish: 'Kuala Lumpur',
    lat: 3.139,
    lng: 101.6869,
    country: 'Malaysia',
  ),
  CityLocation(
    nameBangla: 'জাকার্তা',
    nameEnglish: 'Jakarta',
    lat: -6.2088,
    lng: 106.8456,
    country: 'Indonesia',
  ),
  CityLocation(
    nameBangla: 'টরন্টো',
    nameEnglish: 'Toronto',
    lat: 43.6532,
    lng: -79.3832,
    country: 'Canada',
  ),
  CityLocation(
    nameBangla: 'সিডনি',
    nameEnglish: 'Sydney',
    lat: -33.8688,
    lng: 151.2093,
    country: 'Australia',
  ),
];

// ==========================================================
// Default City
// ==========================================================
const CityLocation defaultCity = CityLocation(
  nameBangla: 'ঢাকা',
  nameEnglish: 'Dhaka',
  lat: 23.8103,
  lng: 90.4125,
  division: 'Dhaka',
  country: 'Bangladesh',
);
