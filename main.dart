import 'hajj_umrah_section.dart';
import 'asmaul_husna_section.dart';
import 'notification_section.dart';
import 'islamic_names_section.dart';
import 'prayer_arc_card.dart';
import 'boyan_section.dart';
import 'namaz_section.dart';
import 'seba_section.dart';
import 'calendar_section.dart';
import 'bibidh_section.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'alarm_timer_section.dart';
import 'timer_section.dart';
import 'qibla_section.dart';
import 'hadith_section.dart';
import 'dua_section.dart';
import 'settings_section.dart';
import 'profile_section.dart';
import 'quran_section.dart';
import 'telawat_section.dart';
import 'tasbih_section.dart';
import 'fasting_section.dart';
import 'important_days_section.dart';
import 'sunnah_section.dart';
import 'others_settings_section.dart';
import 'azan_debug_log_section.dart';
import 'zakat_section.dart'; // <-- যাকাত সেকশন ইমপোর্ট করা হলো

import 'prayer_times.dart';
import 'home_section.dart';
import 'navbar.dart';
import 'cities_data.dart';
import 'amal_section.dart';
import 'prayer_section.dart';
import 'azan_notification_service.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart'
    show Geolocator, LocationAccuracy, LocationPermission, LocationSettings;
import 'package:geocoding/geocoding.dart' show Geocoding;
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AzanNotificationService.instance.init();
  AzanNotificationService.instance.navigatorKey = navigatorKey;
  await AzanNotificationService.instance.checkAppLaunchFromNotification();

  runApp(const NurIslamicApp());
}

class NurIslamicApp extends StatelessWidget {
  const NurIslamicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Nur Islamic App',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('bn', 'BD'),
        Locale('en', 'US'),
      ],
      theme: ThemeData(
        fontFamily: 'NotoSansBengali',
        useMaterial3: true,
      ),
      home: const AppRoot(),
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  String activeTab = 'ilm';
  bool isDarkTheme = false;
  CityLocation selectedCity = defaultCity;
  String calculationMethod = 'IslamicFoundation';

  // প্রথমবার খুললে নিবন্ধনের স্ক্রিন; সেভ করা তথ্য পড়া শেষ না হওয়া পর্যন্ত
  // (কয়েক মিলিসেকেন্ড) ফাঁকা স্ক্রিন, যাতে প্রথমবারের ব্যবহারকারী হোম দেখে না ফেলেন।
  bool _prefsLoaded = false;
  bool _needsRegistration = false;

  // প্রথমবার অ্যাপ খোলার সময় বর্তমান অবস্থান ধরার চেষ্টা একবারই হয় —
  // ব্যবহারকারী অনুমতি না দিলে (denied) বারবার জিজ্ঞেস করা হয় না।
  static const String _autoDetectDoneKey = 'nur_location_autodetect_done';

  @override
  void initState() {
    super.initState();
    _loadSavedPreferences();
  }

  Future<void> _loadSavedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      isDarkTheme = (prefs.getString('nur_theme') ?? 'light') == 'dark';

      final savedCity = prefs.getString('nur_city');
      if (savedCity != null) {
        selectedCity = CityLocation.fromJson(jsonDecode(savedCity));
      }

      calculationMethod =
          prefs.getString('nur_calc_method') ?? 'IslamicFoundation';

      _needsRegistration = !(prefs.getBool(RegistrationStore.doneKey) ?? false);
      _prefsLoaded = true;
    });

    await AzanNotificationService.instance.init();
    await _rescheduleAzanNotifications();

    // নতুন ইনস্টল (সেভ করা শহর নেই) হলে ঢাকার ডিফল্টে না থেকে
    // সাথে সাথে বর্তমান অবস্থান নেওয়া হয়।
    if (prefs.getString('nur_city') == null) {
      final changed = await _autoDetectLocationOnFirstRun(prefs);
      if (changed) {
        await _rescheduleAzanNotifications();
      }
    }
  }

  // ==========================================================
  // প্রথমবার: অনুমতি চেয়ে GPS থেকে আসল lat/lng নিয়ে শহর সেট করে ও সেভ
  // করে। সফল হলে true। ব্যর্থ হলে ডিফল্ট শহরই থাকে।
  // ==========================================================
  Future<bool> _autoDetectLocationOnFirstRun(SharedPreferences prefs) async {
    if (prefs.getBool(_autoDetectDoneKey) ?? false) return false;

    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }

      final granted = perm == LocationPermission.whileInUse ||
          perm == LocationPermission.always;

      if (!granted) {
        // ব্যবহারকারী সিদ্ধান্ত দিয়েছেন (না) — আর জিজ্ঞেস করা হবে না।
        if (perm == LocationPermission.denied ||
            perm == LocationPermission.deniedForever) {
          await prefs.setBool(_autoDetectDoneKey, true);
        }
        _showLocationNote(
            'লোকেশনের অনুমতি দেওয়া হয়নি, তাই ডিফল্ট শহর দেখানো হচ্ছে। ওপরের শহর থেকে নিজে বেছে নিন।');
        return false;
      }

      // ফোনের Location সুইচ বন্ধ থাকলে পরের বার আবার চেষ্টা হবে।
      if (!await Geolocator.isLocationServiceEnabled()) {
        _showLocationNote(
            'ফোনের Location (GPS) বন্ধ আছে। চালু করে অ্যাপ আবার খুলুন।');
        return false;
      }

      // আগে ফোনের সর্বশেষ জানা অবস্থান (সাথে সাথে মেলে), না থাকলে নতুন করে।
      final pos = (await Geolocator.getLastKnownPosition()) ??
          await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 20),
            ),
          );

      final city = await _cityFromCoordinates(pos.latitude, pos.longitude);

      await prefs.setBool(_autoDetectDoneKey, true);
      await _saveCity(city);

      if (!mounted) return false;
      setState(() {
        selectedCity = city;
      });
      _showLocationNote('আপনার অবস্থান: ${city.nameEnglish}');
      return true;
    } catch (e) {
      // অ্যাপ ক্র্যাশ করবে না — ডিফল্ট শহরেই থাকবে, তবে কারণটা দেখানো হবে।
      _showLocationNote('বর্তমান অবস্থান পাওয়া যায়নি: $e');
      return false;
    }
  }

  // প্রথমবারের লোকেশন ধরার ফলাফল/কারণ ব্যবহারকারীকে জানানোর জন্য।
  void _showLocationNote(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  // আসল স্থানাঙ্ক রাখা হয় (নামাজের সময়ের হিসাব সঠিক হওয়ার জন্য);
  // শুধু নামটা শহরের নামে বসানোর চেষ্টা হয়, না পেলে "Current location"।
  Future<CityLocation> _cityFromCoordinates(double lat, double lng) async {
    var nameEnglish = 'Current location';
    var nameBangla = 'বর্তমান অবস্থান';
    var country = '';

    try {
      final marks = await Geocoding()
          .placemarkFromCoordinates(lat, lng)
          .timeout(const Duration(seconds: 6));
      if (marks.isNotEmpty) {
        final m = marks.first;
        final locality = m.locality;
        if (locality != null && locality.isNotEmpty) {
          nameEnglish = locality;
          nameBangla = locality;
        }
        country = m.country ?? '';
      }
    } catch (_) {}

    return CityLocation(
      nameBangla: nameBangla,
      nameEnglish: nameEnglish,
      lat: lat,
      lng: lng,
      country: country,
    );
  }

  Future<void> _rescheduleAzanNotifications() async {
    await AzanNotificationService.instance.scheduleUpcomingPrayers(
      lat: selectedCity.lat,
      lng: selectedCity.lng,
      calculationMethod: calculationMethod,
    );
  }

  Future<void> _saveCity(CityLocation city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_city', jsonEncode(city.toJson()));
  }

  Future<void> _saveTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_theme', dark ? 'dark' : 'light');
  }

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
    _saveTheme(isDarkTheme);
  }

  void setActiveTab(String tab) {
    setState(() {
      activeTab = tab;
    });
  }

  void setSelectedCity(CityLocation city) {
    setState(() {
      selectedCity = city;
    });
    _saveCity(city);
    _rescheduleAzanNotifications();
  }

  void setCalculationMethod(String method) async {
    setState(() {
      calculationMethod = method;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_calc_method', method);
    _rescheduleAzanNotifications();
  }

  PrayerTimesData getPrayerTimes() {
    return calculatePrayerTimes(
      selectedCity.lat,
      selectedCity.lng,
      method: calculationMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_prefsLoaded) {
      return Scaffold(
        backgroundColor:
            isDarkTheme ? const Color(0xFF020617) : const Color(0xFFEEF2F1),
      );
    }

    if (_needsRegistration) {
      return RegistrationScreen(
        isDarkTheme: isDarkTheme,
        onFinished: () {
          if (mounted) setState(() => _needsRegistration = false);
        },
      );
    }

    final prayerTimes = getPrayerTimes();

    return Scaffold(
      backgroundColor:
          isDarkTheme ? const Color(0xFF020617) : const Color(0xFFEEF2F1),
      appBar: NavbarHeader(
        selectedCity: selectedCity,
        setSelectedCity: setSelectedCity,
        setActiveTab: setActiveTab,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: _buildActiveSection(prayerTimes),
      ),
      bottomNavigationBar: PrimaryBottomNav(
        activeTab: activeTab,
        setActiveTab: setActiveTab,
      ),
    );
  }

  Widget _buildActiveSection(PrayerTimesData prayerTimes) {
    switch (activeTab) {
      case 'home':
      case 'ilm':
        return HomeSection(
          prayerTimes: prayerTimes,
          selectedCity: selectedCity,
          setActiveTab: setActiveTab,
          onMuteChanged: _rescheduleAzanNotifications,
        );

      case 'amal':
        return AmalSection(
          setActiveTab: setActiveTab,
        );

      case 'seba':
        return SebaSection(setActiveTab: setActiveTab);

      case 'zakat': // <-- এখানে যাকাত সেকশন রাউটিং যুক্ত করা হলো
        return ZakatSection(setActiveTab: setActiveTab);

      case 'prayer':
        return PrayerSection(
          prayerTimes: prayerTimes,
          selectedCity: selectedCity,
          setSelectedCity: setSelectedCity,
          calculationMethod: calculationMethod,
          setCalculationMethod: setCalculationMethod,
          isDarkTheme: isDarkTheme,
          onMuteChanged: _rescheduleAzanNotifications,
        );

      case 'tasbih':
        return TasbihSection(
          isDarkTheme: isDarkTheme,
        );

      case 'fasting':
        return const FastingSection();
      case 'hajj':
        return HajjUmrahSection(selectedCity: selectedCity);

      case 'quran':
        return QuranSection();

      case 'hadith':
        return HadithSection();

      case 'telawat':
        return const TelawatSection();

      case 'namaz':
        return const NamazSection();

      case 'boyan':
        return const BoyanSection();

      case 'dua':
        return DuaSection();
      case 'asmaul_husna':
        return AsmaulHusnaSection(setActiveTab: setActiveTab);

      case 'settings':
        return const Center(
          child: Text(
            'সেটিংস সেকশন খুব শীঘ্রই আসছে',
            style: TextStyle(fontSize: 18),
          ),
        );
      case 'calendar':
        return CalendarSection(selectedCity: selectedCity);
      case 'qibla':
        return QiblaSection(selectedCity: selectedCity);

      case 'alarm':
        return const AlarmTimerSection();

      case 'notification':
        return const NotificationSection();

      case 'islamic_names':
        return IslamicNamesSection(isDarkTheme: isDarkTheme);

      case 'important_days':
        return ImportantDaysSection(setActiveTab: setActiveTab);

      case 'sunnah':
        return SunnahSection(setActiveTab: setActiveTab);

      case 'azan_debug':
        return AzanDebugLogSection(setActiveTab: setActiveTab);

      case 'others_settings':
        return OthersSettingsSection(setActiveTab: setActiveTab);

      case 'profile':
        return ProfileSection(setActiveTab: setActiveTab);

      case 'bibidh':
        return BibidhSection(setActiveTab: setActiveTab);

      default:
        return _placeholderSection('এই সেকশন এখনো বানানো হয়নি: $activeTab');
    }
  }

  Widget _placeholderSection(String label) {
    return Container(
      padding: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: isDarkTheme ? Colors.white70 : Colors.black87),
      ),
    );
  }
}
