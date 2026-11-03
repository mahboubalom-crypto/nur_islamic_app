import 'dart:async';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

// ==========================================
// MODELS
// ==========================================

class WorldClockCity {
  final String tzId;
  final String name;
  final String country;
  final double utcOffsetHours; // fallback only

  const WorldClockCity({
    required this.tzId,
    required this.name,
    required this.country,
    required this.utcOffsetHours,
  });
}

const List<WorldClockCity> kAvailableCities = [
  WorldClockCity(
      tzId: 'Asia/Dhaka',
      name: 'Dhaka',
      country: 'Bangladesh',
      utcOffsetHours: 6.0),
  WorldClockCity(
      tzId: 'Asia/Kolkata',
      name: 'Kolkata',
      country: 'India',
      utcOffsetHours: 5.5),
  WorldClockCity(
      tzId: 'Asia/Karachi',
      name: 'Karachi',
      country: 'Pakistan',
      utcOffsetHours: 5.0),
  WorldClockCity(
      tzId: 'Asia/Kathmandu',
      name: 'Kathmandu',
      country: 'Nepal',
      utcOffsetHours: 5.75),
  WorldClockCity(
      tzId: 'Asia/Colombo',
      name: 'Colombo',
      country: 'Sri Lanka',
      utcOffsetHours: 5.5),
  WorldClockCity(
      tzId: 'Europe/London',
      name: 'London',
      country: 'United Kingdom',
      utcOffsetHours: 1.0),
  WorldClockCity(
      tzId: 'Europe/Paris',
      name: 'Paris',
      country: 'France',
      utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'Europe/Berlin',
      name: 'Berlin',
      country: 'Germany',
      utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'Europe/Madrid',
      name: 'Madrid',
      country: 'Spain',
      utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'Europe/Rome', name: 'Rome', country: 'Italy', utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'Europe/Istanbul',
      name: 'Istanbul',
      country: 'Turkey',
      utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Europe/Moscow',
      name: 'Moscow',
      country: 'Russia',
      utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Europe/Amsterdam',
      name: 'Amsterdam',
      country: 'Netherlands',
      utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'America/New_York',
      name: 'New York',
      country: 'USA',
      utcOffsetHours: -4.0),
  WorldClockCity(
      tzId: 'America/Los_Angeles',
      name: 'Los Angeles',
      country: 'USA',
      utcOffsetHours: -7.0),
  WorldClockCity(
      tzId: 'America/Chicago',
      name: 'Chicago',
      country: 'USA',
      utcOffsetHours: -5.0),
  WorldClockCity(
      tzId: 'America/Toronto',
      name: 'Toronto',
      country: 'Canada',
      utcOffsetHours: -4.0),
  WorldClockCity(
      tzId: 'America/Sao_Paulo',
      name: 'Sao Paulo',
      country: 'Brazil',
      utcOffsetHours: -3.0),
  WorldClockCity(
      tzId: 'America/Mexico_City',
      name: 'Mexico City',
      country: 'Mexico',
      utcOffsetHours: -6.0),
  WorldClockCity(
      tzId: 'Asia/Dubai', name: 'Dubai', country: 'UAE', utcOffsetHours: 4.0),
  WorldClockCity(
      tzId: 'Asia/Riyadh',
      name: 'Riyadh',
      country: 'Saudi Arabia',
      utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Asia/Qatar', name: 'Doha', country: 'Qatar', utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Asia/Baghdad',
      name: 'Baghdad',
      country: 'Iraq',
      utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Asia/Tehran',
      name: 'Tehran',
      country: 'Iran',
      utcOffsetHours: 3.5),
  WorldClockCity(
      tzId: 'Asia/Jerusalem',
      name: 'Jerusalem',
      country: 'Israel',
      utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Africa/Cairo',
      name: 'Cairo',
      country: 'Egypt',
      utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'Africa/Lagos',
      name: 'Lagos',
      country: 'Nigeria',
      utcOffsetHours: 1.0),
  WorldClockCity(
      tzId: 'Africa/Johannesburg',
      name: 'Johannesburg',
      country: 'South Africa',
      utcOffsetHours: 2.0),
  WorldClockCity(
      tzId: 'Africa/Nairobi',
      name: 'Nairobi',
      country: 'Kenya',
      utcOffsetHours: 3.0),
  WorldClockCity(
      tzId: 'Asia/Tokyo', name: 'Tokyo', country: 'Japan', utcOffsetHours: 9.0),
  WorldClockCity(
      tzId: 'Asia/Shanghai',
      name: 'Shanghai',
      country: 'China',
      utcOffsetHours: 8.0),
  WorldClockCity(
      tzId: 'Asia/Hong_Kong',
      name: 'Hong Kong',
      country: 'Hong Kong',
      utcOffsetHours: 8.0),
  WorldClockCity(
      tzId: 'Asia/Seoul',
      name: 'Seoul',
      country: 'South Korea',
      utcOffsetHours: 9.0),
  WorldClockCity(
      tzId: 'Asia/Singapore',
      name: 'Singapore',
      country: 'Singapore',
      utcOffsetHours: 8.0),
  WorldClockCity(
      tzId: 'Asia/Kuala_Lumpur',
      name: 'Kuala Lumpur',
      country: 'Malaysia',
      utcOffsetHours: 8.0),
  WorldClockCity(
      tzId: 'Asia/Bangkok',
      name: 'Bangkok',
      country: 'Thailand',
      utcOffsetHours: 7.0),
  WorldClockCity(
      tzId: 'Asia/Jakarta',
      name: 'Jakarta',
      country: 'Indonesia',
      utcOffsetHours: 7.0),
  WorldClockCity(
      tzId: 'Asia/Manila',
      name: 'Manila',
      country: 'Philippines',
      utcOffsetHours: 8.0),
  WorldClockCity(
      tzId: 'Australia/Sydney',
      name: 'Sydney',
      country: 'Australia',
      utcOffsetHours: 10.0),
  WorldClockCity(
      tzId: 'Australia/Melbourne',
      name: 'Melbourne',
      country: 'Australia',
      utcOffsetHours: 10.0),
  WorldClockCity(
      tzId: 'Pacific/Auckland',
      name: 'Auckland',
      country: 'New Zealand',
      utcOffsetHours: 12.0),
];

// ==========================================
// WIDGET
// ==========================================

class WorldClockSection extends StatefulWidget {
  const WorldClockSection({super.key});

  @override
  State<WorldClockSection> createState() => _WorldClockSectionState();
}

class _WorldClockSectionState extends State<WorldClockSection> {
  Timer? _timer;
  bool _tzReady = false;

  final List<String> _activeTzIds = [
    'Europe/London',
    'America/New_York',
    'Asia/Dhaka',
  ];

  @override
  void initState() {
    super.initState();
    try {
      tzdata.initializeTimeZones();
    } catch (_) {}
    _tzReady = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  DateTime _cityNow(WorldClockCity city) {
    try {
      return tz.TZDateTime.now(tz.getLocation(city.tzId));
    } catch (_) {
      final utcNow = DateTime.now().toUtc();
      return utcNow.add(Duration(minutes: (city.utcOffsetHours * 60).round()));
    }
  }

  int _hourDiffFromLocal(WorldClockCity city) {
    final localCity =
        kAvailableCities.firstWhere((c) => c.tzId == 'Asia/Dhaka');
    final local = _cityNow(localCity);
    final target = _cityNow(city);
    return target.difference(local).inHours;
  }

  void _addCity(WorldClockCity city) {
    setState(() => _activeTzIds.add(city.tzId));
  }

  void _removeCity(String tzId) {
    setState(() => _activeTzIds.remove(tzId));
  }

  void _showAddCityDialog() {
    final available =
        kAvailableCities.where((c) => !_activeTzIds.contains(c.tzId)).toList();
    String query = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = available.where((c) {
              final q = query.toLowerCase();
              return c.name.toLowerCase().contains(q) ||
                  c.country.toLowerCase().contains(q);
            }).toList();

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
                ),
                child: SizedBox(
                  height: MediaQuery.of(ctx).size.height * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add City',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'City or country',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[500]),
                          filled: true,
                          fillColor: const Color(0xFF2C2C2E),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (v) => setModalState(() => query = v),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: filtered.isEmpty
                            ? const Center(
                                child: Text(
                                  'No matching city',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (ctx, i) {
                                  final c = filtered[i];
                                  return InkWell(
                                    onTap: () {
                                      _addCity(c);
                                      Navigator.pop(ctx);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              c.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            c.country,
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_tzReady) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'World Clock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon:
                    const Icon(Icons.add_circle, color: Colors.blue, size: 28),
                onPressed: _showAddCityDialog,
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._activeTzIds.map((tzId) {
            final city = kAvailableCities.firstWhere(
              (c) => c.tzId == tzId,
              orElse: () => kAvailableCities[0],
            );
            final now = _cityNow(city);
            final h = now.hour.toString().padLeft(2, '0');
            final m = now.minute.toString().padLeft(2, '0');
            final timeString = '$h:$m';
            final diff = _hourDiffFromLocal(city);
            final diffLabel = diff == 0
                ? 'Today, same time'
                : 'Today, ${diff > 0 ? '+' : ''}$diff h';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          diffLabel,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          timeString,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w300,
                            fontFeatures: [FontFeature.tabularFigures()],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _removeCity(city.tzId),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(Icons.close,
                                size: 16, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
