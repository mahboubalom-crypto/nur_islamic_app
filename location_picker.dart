import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'cities_data.dart';

Future<void> showLocationPicker({
  required BuildContext context,
  required void Function(CityLocation city) onCitySelected,
  required void Function(double lat, double lng) onGpsLocation,
}) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _LocationPickerSheet(
      onCitySelected: onCitySelected,
      onGpsLocation: onGpsLocation,
    ),
  );
}

class _LocationPickerSheet extends StatefulWidget {
  final void Function(CityLocation city) onCitySelected;
  final void Function(double lat, double lng) onGpsLocation;

  const _LocationPickerSheet({
    required this.onCitySelected,
    required this.onGpsLocation,
  });

  @override
  State<_LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<_LocationPickerSheet> {
  bool isLoading = false;
  String? errorMsg;

  // ==========================================================
  // GPS coordinate থেকে আসল জায়গার নাম বের করার চেষ্টা করে
  // (reverse-geocoding)। কোনো কারণে ব্যর্থ হলে (নেটওয়ার্ক না থাকা,
  // geocoding সাপোর্ট না থাকা ইত্যাদি) নিরাপদে 'Current Location'-এ
  // fallback করে — এতে GPS location select করা কখনো ভাঙবে না।
  // ==========================================================
  Future<(String bangla, String english)> _resolvePlaceName(
    double latitude,
    double longitude,
  ) async {
    try {
      final geocoding = Geocoding();
      final placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final String? maybeName =
            (p.locality != null && p.locality!.trim().isNotEmpty)
                ? p.locality!.trim()
                : (p.subAdministrativeArea != null &&
                        p.subAdministrativeArea!.trim().isNotEmpty)
                    ? p.subAdministrativeArea!.trim()
                    : (p.administrativeArea != null &&
                            p.administrativeArea!.trim().isNotEmpty)
                        ? p.administrativeArea!.trim()
                        : null;
        if (maybeName != null) {
          final String resolvedName = maybeName;
          return (resolvedName, resolvedName);
        }
      }
    } catch (_) {
      // fallback নিচে
    }
    return ('বর্তমান অবস্থান', 'Current Location');
  }

  // ==========================================================
  // GPS দিয়ে বর্তমান অবস্থান শনাক্ত
  // ==========================================================
  Future<void> _detectGpsLocation() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMsg = null;
    });

    try {
      // ========================================================
      // Location Service চালু আছে কিনা
      // ========================================================
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'ফোনের GPS/Location চালু করুন।',
        );
      }

      // ========================================================
      // Location Permission
      // ========================================================
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission দেওয়া হয়নি।',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission স্থায়ীভাবে বন্ধ। '
          'ফোনের Settings থেকে Location permission চালু করুন।',
        );
      }

      // ========================================================
      // GPS Coordinate
      // ========================================================
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final double latitude = position.latitude;
      final double longitude = position.longitude;

      // ========================================================
      // GPS coordinate App-এ পাঠানো
      // ========================================================
      widget.onGpsLocation(
        latitude,
        longitude,
      );

      // ========================================================
      // আসল জায়গার নাম খোঁজা (reverse-geocoding), ব্যর্থ হলে
      // 'Current Location'-এ fallback
      // ========================================================
      final (nameBangla, nameEnglish) =
          await _resolvePlaceName(latitude, longitude);

      final location = CityLocation(
        nameBangla: nameBangla,
        nameEnglish: nameEnglish,
        lat: latitude,
        lng: longitude,
        country: 'Bangladesh',
      );

      // ========================================================
      // Selected location App-এ পাঠানো
      // ========================================================
      widget.onCitySelected(location);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // ========================================================
      // Popup বন্ধ
      // ========================================================
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMsg = e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  // ==========================================================
  // Popup UI
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF2F5F4),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: _buildMenuView(),
      ),
    );
  }

  // ==========================================================
  // Location Menu
  // ==========================================================
  Widget _buildMenuView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(
            bottom: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // ======================================================
        // Error Message
        // ======================================================
        if (errorMsg != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              errorMsg!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),

        // ======================================================
        // Loading
        // ======================================================
        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text(
                  'বর্তমান অবস্থান শনাক্ত করা হচ্ছে...',
                  style: TextStyle(
                    color: Color(0xFF2E5B4B),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          )
        else
          // ====================================================
          // GPS Button
          // ====================================================
          _menuOption(
            label: 'অবস্থান শনাক্ত করুন',
            subtitle: 'GPS দিয়ে বর্তমান অবস্থান শনাক্ত করুন',
            onTap: _detectGpsLocation,
          ),
      ],
    );
  }

  // ==========================================================
  // Menu Option
  // ==========================================================
  Widget _menuOption({
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF39764E).withValues(
                  alpha: 0.10,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.my_location,
                color: Color(0xFF39764E),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF2E5B4B),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF39764E),
            ),
          ],
        ),
      ),
    );
  }
}
