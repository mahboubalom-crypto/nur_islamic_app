import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'cities_data.dart';
import 'qibla.dart';

class QiblaSection extends StatefulWidget {
  final CityLocation selectedCity;

  const QiblaSection({
    super.key,
    required this.selectedCity,
  });

  @override
  State<QiblaSection> createState() => _QiblaSectionState();
}

class _QiblaSectionState extends State<QiblaSection> {
  double deviceHeading = 0;

  bool useGps = false;
  double userLat = 0;
  double userLng = 0;

  bool isLoadingLocation = false;
  String? locationError;

  StreamSubscription<CompassEvent>? _compassSubscription;
  bool compassAvailable = true;

  @override
  void initState() {
    super.initState();

    userLat = widget.selectedCity.lat;
    userLng = widget.selectedCity.lng;

    _listenToCompass();
  }

  @override
  void didUpdateWidget(QiblaSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!useGps &&
        oldWidget.selectedCity.nameEnglish != widget.selectedCity.nameEnglish) {
      setState(() {
        userLat = widget.selectedCity.lat;
        userLng = widget.selectedCity.lng;
      });
    }
  }

  // ==========================================================
  // Compass
  // ==========================================================
  void _listenToCompass() {
    if (FlutterCompass.events == null) {
      if (mounted) {
        setState(() {
          compassAvailable = false;
        });
      }
      return;
    }

    _compassSubscription = FlutterCompass.events!.listen((event) {
      if (event.heading != null && mounted) {
        setState(() {
          deviceHeading = event.heading!;
        });
      }
    });
  }

  // ==========================================================
  // সরাসরি GPS Location
  // ==========================================================
  Future<void> _handleDetectLocation() async {
    if (isLoadingLocation) {
      return;
    }

    setState(() {
      isLoadingLocation = true;
      locationError = null;
    });

    try {
      // --------------------------------------------------------
      // Location service চালু আছে কিনা
      // --------------------------------------------------------
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'ফোনের GPS / Location Service চালু করুন।',
        );
      }

      // --------------------------------------------------------
      // Permission
      // --------------------------------------------------------
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission দেওয়া হয়নি।',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission স্থায়ীভাবে বন্ধ আছে। ফোনের Settings থেকে Location permission চালু করুন।',
        );
      }

      // --------------------------------------------------------
      // সরাসরি GPS position
      // --------------------------------------------------------
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // --------------------------------------------------------
      // GPS coordinates সেট
      // --------------------------------------------------------
      if (!mounted) {
        return;
      }

      setState(() {
        userLat = position.latitude;
        userLng = position.longitude;
        useGps = true;
        isLoadingLocation = false;
        locationError = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'GPS লোকেশন পাওয়া গেছে\n'
            'Lat: ${position.latitude.toStringAsFixed(6)}\n'
            'Lng: ${position.longitude.toStringAsFixed(6)}',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoadingLocation = false;
        locationError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  // ==========================================================
  // GPS বাদ দিয়ে আবার Selected City
  // ==========================================================
  void _useSelectedCity() {
    setState(() {
      useGps = false;
      userLat = widget.selectedCity.lat;
      userLng = widget.selectedCity.lng;
      locationError = null;
    });
  }

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }

  // ==========================================================
  // Main Build
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    final qiblaData = calculateQibla(
      userLat,
      userLng,
    );

    final needleRotation = qiblaData.qiblaBearing - deviceHeading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 16),
        _buildCompassCard(
          qiblaData,
          needleRotation,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ==========================================================
  // Header
  // ==========================================================
  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF064E3B),
            Color(0xFF0F2E2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.explore,
                color: Colors.amber,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'কিবলা কম্পাস (Qibla Direction)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'পবিত্র কাবার সঠিক দিক ও দূরত্ব নির্ণয় করুন',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // Compass Card
  // ==========================================================
  Widget _buildCompassCard(
    QiblaData qiblaData,
    double needleRotation,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade700,
        ),
      ),
      child: Column(
        children: [
          // ----------------------------------------------------
          // Location badges
          // ----------------------------------------------------
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _infoBadge(
                useGps
                    ? 'স্থান: GPS বর্তমান লোকেশন'
                    : 'স্থান: ${widget.selectedCity.nameBangla} (${widget.selectedCity.nameEnglish})',
                Colors.green,
              ),
              _infoBadge(
                'কিবলা বিয়ারিং: ${qiblaData.qiblaBearing.toStringAsFixed(1)}° উত্তর দিক হতে',
                Colors.amber,
              ),
              _infoBadge(
                'কাবার দূরত্ব: ${qiblaData.distanceKm.toStringAsFixed(0)} কি.মি.',
                Colors.grey,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ----------------------------------------------------
          // GPS error
          // ----------------------------------------------------
          if (locationError != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                locationError!,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ----------------------------------------------------
          // Compass unavailable
          // ----------------------------------------------------
          if (!compassAvailable)
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'এই ডিভাইসে কম্পাস সেন্সর পাওয়া যায়নি',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // ----------------------------------------------------
          // Compass Dial
          // ----------------------------------------------------
          SizedBox(
            width: 240,
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF0A0A0A),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.4),
                      width: 4,
                    ),
                  ),
                ),

                const Positioned(
                  top: 10,
                  child: Text(
                    'উত্তর',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Positioned(
                  right: 14,
                  child: Text(
                    'পূর্ব',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),

                const Positioned(
                  bottom: 10,
                  child: Text(
                    'দক্ষিণ',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),

                const Positioned(
                  left: 14,
                  child: Text(
                    'পশ্চিম',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),

                // ------------------------------------------------
                // Qibla Needle
                // ------------------------------------------------
                AnimatedRotation(
                  turns: needleRotation / 360,
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Emoji বাদ দিয়ে icon ব্যবহার করা হয়েছে
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.amber.shade200,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.mosque,
                          size: 18,
                          color: Colors.black87,
                        ),
                      ),

                      Container(
                        width: 3,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.amber,
                              Colors.green.shade400,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ------------------------------------------------
                // Center
                // ------------------------------------------------
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                    border: Border.all(
                      color: const Color(0xFF0A0A0A),
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------
          // GPS Button
          // ----------------------------------------------------
          if (isLoadingLocation)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            )
          else
            ElevatedButton.icon(
              onPressed: _handleDetectLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(
                Icons.near_me,
                size: 16,
              ),
              label: const Text(
                'আমার জিপিএস লোকেশন নির্ণয় করুন',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // ----------------------------------------------------
          // GPS চালু থাকলে City-তে ফেরার button
          // ----------------------------------------------------
          if (useGps) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _useSelectedCity,
              child: const Text(
                'নির্বাচিত স্থানে ফিরে যান',
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ----------------------------------------------------
          // Instruction
          // ----------------------------------------------------
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber,
                      size: 14,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'কম্পাস সঠিক রাখার উপায়:',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '১. আপনার ফোনটি সমতল টেবিলে বা হাতের তালুতে সোজা করে রাখুন।',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    top: 4,
                  ),
                  child: Text(
                    '২. কোনো চুম্বক বা ধাতব বস্তু থেকে ফোন দূরে রাখুন।',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // Info Badge
  // ==========================================================
  Widget _infoBadge(
    String text,
    MaterialColor color,
  ) {
    final backgroundColor = color.shade900.withValues(alpha: 0.6);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.shade800,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.shade300,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
