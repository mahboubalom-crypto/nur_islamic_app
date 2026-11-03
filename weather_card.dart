// ==========================================================
// WeatherCard — Open-Meteo API দিয়ে আবহাওয়ার কার্ড (Google-স্টাইল)
//
// • ওপরে: নির্বাচিত দিনের সারাংশ (আজ হলে "এখন" + অনুভূত তাপমাত্রা)
// • মাঝে: ২৪ ঘণ্টার ঘণ্টাভিত্তিক তালিকা — ডানে টেনে দেখা যায়
// • নিচে: দিনের টাইল — যেকোনো দিনে ট্যাপ করলে সেই দিনের ২৪ ঘণ্টা আসে
//   (আজ নির্বাচিত থাকলে এই মুহূর্ত থেকে পরের ২৪ ঘণ্টা)
//
// ✅ কোনো নতুন প্যাকেজ লাগে না: http, geolocator, shared_preferences
// ✅ বাংলা/ইংরেজি: অ্যাপের locale 'en' হলে ইংরেজি, নইলে বাংলা
// ✅ শহর: HomeSection থেকে আসা selectedCity; লোকেশন বাটনে GPS
// ✅ Loading / Error / সর্বশেষ সফল তথ্যের cache
// ==========================================================
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'cities_data.dart';

class WeatherCard extends StatefulWidget {
  final CityLocation selectedCity;

  const WeatherCard({super.key, required this.selectedCity});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  static const String _prefsUseGpsKey = 'nur_weather_use_gps';
  static const String _prefsCachePrefix = 'nur_weather_cache_v2_';

  bool _loading = true;
  bool _fromCache = false;
  bool _useGps = false;
  double? _gpsLat;
  double? _gpsLng;
  _WeatherData? _data;
  int _requestId = 0;
  int _selectedDay = 0;
  final ScrollController _hourScroll = ScrollController();

  double get _lat =>
      (_useGps && _gpsLat != null) ? _gpsLat! : widget.selectedCity.lat;
  double get _lng =>
      (_useGps && _gpsLng != null) ? _gpsLng! : widget.selectedCity.lng;

  bool get _isBn => Localizations.localeOf(context).languageCode != 'en';

  String _t(String bn, String en) => _isBn ? bn : en;

  String _digits(String s) {
    if (!_isBn) return s;
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return s.replaceAllMapped(RegExp(r'\d'), (m) => bn[int.parse(m[0]!)]);
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _hourScroll.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed = oldWidget.selectedCity.lat != widget.selectedCity.lat ||
        oldWidget.selectedCity.lng != widget.selectedCity.lng;
    // GPS চালু থাকলে শহর বদলালেও বর্তমান অবস্থানের আবহাওয়াই থাকবে।
    if (changed && !_useGps) {
      _selectedDay = 0;
      _load();
    }
  }

  Future<void> _start() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_prefsUseGpsKey) ?? false) {
        // এখানে অনুমতি চাওয়া হয় না — আগে দেওয়া থাকলে তবেই GPS ব্যবহার হবে।
        // (প্রথমবারের স্বয়ংক্রিয় লোকেশন main.dart-এ সেট হয়, তাই
        // selectedCity-ই তখন বর্তমান অবস্থান।)
        _useGps = await _tryGps(askPermission: false);
      }
    } catch (_) {}
    if (!mounted) return;
    await _load();
  }

  // ----------------------------------------------------------
  // GPS
  // ----------------------------------------------------------
  Future<bool> _tryGps({required bool askPermission}) async {
    try {
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied && askPermission) {
        perm = await Geolocator.requestPermission();
      }
      final granted = perm == LocationPermission.whileInUse ||
          perm == LocationPermission.always;
      if (!granted) return false;
      if (!await Geolocator.isLocationServiceEnabled()) return false;

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 10),
        ),
      );
      _gpsLat = pos.latitude;
      _gpsLng = pos.longitude;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _toggleGps() async {
    final prefs = await SharedPreferences.getInstance();

    if (_useGps) {
      _useGps = false;
      _selectedDay = 0;
      await prefs.setBool(_prefsUseGpsKey, false);
      await _load();
      return;
    }

    final ok = await _tryGps(askPermission: true);
    if (!mounted) return;

    if (ok) {
      _useGps = true;
      _selectedDay = 0;
      await prefs.setBool(_prefsUseGpsKey, true);
      await _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t(
            'বর্তমান অবস্থান পাওয়া যায়নি, নির্বাচিত শহরের আবহাওয়া দেখানো হচ্ছে',
            'Could not get your location. Showing the selected city.',
          )),
        ),
      );
    }
  }

  // ----------------------------------------------------------
  // API + cache
  // ----------------------------------------------------------
  String _cacheKey(double lat, double lng) =>
      '$_prefsCachePrefix${lat.toStringAsFixed(2)}_${lng.toStringAsFixed(2)}';

  Future<void> _load() async {
    final id = ++_requestId;
    final lat = _lat;
    final lng = _lng;

    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    try {
      final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
        'latitude': lat.toString(),
        'longitude': lng.toString(),
        'current':
            'temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m,is_day',
        'hourly':
            'temperature_2m,relative_humidity_2m,precipitation_probability,weather_code,wind_speed_10m,is_day',
        'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
        'forecast_days': '6', // আজ + আগামী ৫ দিন
        'timezone': 'auto',
        'wind_speed_unit': 'kmh',
      });

      final res = await http.get(uri).timeout(const Duration(seconds: 12));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final weather = _WeatherData.fromJson(json);

      // cache লেখা ব্যর্থ হলেও সফল তথ্য যেন নষ্ট না হয়।
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_cacheKey(lat, lng), res.body);
      } catch (_) {}

      if (!mounted || id != _requestId) return;
      setState(() {
        _data = weather;
        _loading = false;
        _fromCache = false;
      });
    } catch (_) {
      final cached = await _readCache(_cacheKey(lat, lng));
      if (!mounted || id != _requestId) return;
      setState(() {
        _data = cached;
        _loading = false;
        _fromCache = cached != null;
      });
    }
  }

  Future<_WeatherData?> _readCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;
      return _WeatherData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  void _selectDay(int index) {
    if (index == _selectedDay) return;
    setState(() => _selectedDay = index);
    if (_hourScroll.hasClients) _hourScroll.jumpTo(0);
  }

  // ----------------------------------------------------------
  // UI
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = dark ? Colors.white : const Color(0xFF0F2E2A);
    final subColor = dark ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF0F172A) : const Color(0xFFEFF7F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? const Color(0xFF1E293B) : const Color(0xFFCFE5D6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(dark, titleColor, subColor),
          const SizedBox(height: 10),
          _buildBody(dark, titleColor, subColor),
        ],
      ),
    );
  }

  Widget _buildHeader(bool dark, Color titleColor, Color subColor) {
    final placeName = _useGps
        ? _t('বর্তমান অবস্থান', 'Current location')
        : _t(widget.selectedCity.nameBangla, widget.selectedCity.nameEnglish);

    return Row(
      children: [
        Container(
          width: 4,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _t('আবহাওয়া', 'Weather'),
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                placeName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: subColor, fontSize: 11),
              ),
            ],
          ),
        ),
        _miniButton(
          icon: _useGps ? Icons.my_location : Icons.location_searching,
          active: _useGps,
          dark: dark,
          onTap: _toggleGps,
        ),
        const SizedBox(width: 8),
        _miniButton(
          icon: Icons.refresh,
          active: false,
          dark: dark,
          onTap: _load,
        ),
      ],
    );
  }

  Widget _miniButton({
    required IconData icon,
    required bool active,
    required bool dark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? Colors.green[700]
              : (dark ? const Color(0xFF1E293B) : Colors.white),
          border: Border.all(
            color: active
                ? Colors.green[700]!
                : (dark ? const Color(0xFF334155) : const Color(0xFFCFE5D6)),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active
              ? Colors.white
              : (dark ? Colors.green[300] : Colors.green[700]),
        ),
      ),
    );
  }

  Widget _buildBody(bool dark, Color titleColor, Color subColor) {
    final data = _data;

    if (data == null) {
      if (_loading) return _buildLoading(subColor);
      return _buildError(dark, subColor);
    }

    final sel = _selectedDay.clamp(0, data.days.length - 1).toInt();
    final hours = data.hoursFor(sel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_loading)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                minHeight: 2,
                color: Colors.green[600],
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        _buildSummary(data, sel, dark, titleColor, subColor),
        if (hours.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildHourly(hours, sel == 0, dark, titleColor, subColor),
        ],
        const SizedBox(height: 12),
        _buildDayTiles(data, sel, dark, titleColor, subColor),
        if (_fromCache) ...[
          const SizedBox(height: 8),
          Text(
            _t(
              'ইন্টারনেট নেই — সর্বশেষ সংরক্ষিত তথ্য দেখানো হচ্ছে',
              'No connection — showing last saved data',
            ),
            style: TextStyle(color: subColor, fontSize: 10),
          ),
        ],
      ],
    );
  }

  Widget _buildLoading(Color subColor) {
    return SizedBox(
      height: 96,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _t('আবহাওয়ার তথ্য আনা হচ্ছে...', 'Loading weather...'),
              style: TextStyle(color: subColor, fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(bool dark, Color subColor) {
    return SizedBox(
      height: 110,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 30, color: subColor),
            const SizedBox(height: 6),
            Text(
              _t(
                'আবহাওয়ার তথ্য আনা যায়নি। ইন্টারনেট সংযোগ দেখে আবার চেষ্টা করুন।',
                'Could not load weather. Check your connection and try again.',
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: subColor, fontSize: 11.5),
            ),
            TextButton(
              onPressed: _load,
              child: Text(
                _t('আবার চেষ্টা করুন', 'Try again'),
                style: TextStyle(
                  color: Colors.green[dark ? 300 : 700],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // নির্বাচিত দিনের সারাংশ
  // ----------------------------------------------------------
  Widget _buildSummary(
      _WeatherData data, int sel, bool dark, Color titleColor, Color subColor) {
    final isToday = sel == 0;
    final day = data.days[sel];
    final code = isToday ? data.code : day.code;
    final night = isToday && !data.isDay;
    final info = _infoFor(code, isDay: !night);
    final kind = _kindFor(code);

    final bigTemp = isToday ? data.temp : day.max;
    final bigText =
        bigTemp == null ? '--' : '${_digits(bigTemp.round().toString())}°C';
    final label = isToday ? _t('এখন', 'Now') : _dayFullName(day.date);

    final dayHours = data.hoursFor(sel);
    final humidity =
        isToday ? data.humidity : _average(dayHours.map((h) => h.humidity));
    final wind = isToday ? data.wind : _average(dayHours.map((h) => h.wind));

    final subLine = isToday
        ? '${_t('অনুভূত', 'Feels like')} ${_tempText(data.feelsLike)}'
        : '${_t('সর্বনিম্ন', 'Low')} ${_tempText(day.min)}';

    final humidityText =
        humidity == null ? '--' : '${_digits(humidity.round().toString())}%';
    final windText = wind == null
        ? '--'
        : '${_digits(wind.round().toString())} ${_t('কি.মি./ঘণ্টা', 'km/h')}';

    // অ্যানিমেটেড আকাশের ওপর লেখা — সব সময় সাদা, যাতে পড়া যায়।
    const onScene = Colors.white;
    const onSceneSoft = Colors.white70;
    final iconColor =
        (kind == _SceneKind.clear || kind == _SceneKind.partly) && !night
            ? const Color(0xFFFFD54F)
            : Colors.white;

    return _SceneBackground(
      kind: kind,
      night: night,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: onSceneSoft,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  bigText,
                  style: const TextStyle(
                    color: onScene,
                    fontWeight: FontWeight.w800,
                    fontSize: 34,
                    height: 1.1,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(info.icon, size: 34, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _t(info.bn, info.en),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: onScene,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subLine,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          color: onSceneSoft,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                _statRow(Icons.water_drop_outlined, _t('আর্দ্রতা', 'Humidity'),
                    humidityText, dark, onScene, onSceneSoft,
                    iconColor: onSceneSoft),
                const SizedBox(width: 22),
                _statRow(Icons.air, _t('বাতাস', 'Wind'), windText, dark,
                    onScene, onSceneSoft,
                    iconColor: onSceneSoft),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value, bool dark,
      Color titleColor, Color subColor,
      {Color? iconColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 15, color: iconColor ?? Colors.green[dark ? 300 : 700]),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: subColor, fontSize: 9.5)),
            Text(
              value,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // ২৪ ঘণ্টার তালিকা (ডানে টানলে আরও আসে)
  // ----------------------------------------------------------
  Widget _buildHourly(List<_Hour> hours, bool isToday, bool dark,
      Color titleColor, Color subColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF111C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: SizedBox(
        height: 82,
        child: ListView.builder(
          controller: _hourScroll,
          scrollDirection: Axis.horizontal,
          itemCount: hours.length,
          itemBuilder: (context, i) {
            return _hourItem(hours[i], isToday && i == 0, titleColor, subColor);
          },
        ),
      ),
    );
  }

  Widget _hourItem(_Hour hour, bool isNow, Color titleColor, Color subColor) {
    final info = _infoFor(hour.code, isDay: hour.isDay);
    final timeText = isNow
        ? _t('এখন', 'Now')
        : _digits('${hour.time.hour.toString().padLeft(2, '0')}:00');

    return SizedBox(
      width: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_digits(hour.temp.round().toString())}°',
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          SizedBox(
            height: 14,
            child: hour.pop >= 10
                ? Text(
                    '${_digits(hour.pop.toString())}%',
                    style: const TextStyle(
                      color: Color(0xFF3B82F6),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          Icon(info.icon, size: 22, color: info.color),
          const SizedBox(height: 4),
          Text(
            timeText,
            style: TextStyle(color: subColor, fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // দিনের টাইল — ট্যাপ করলে সেই দিনের ২৪ ঘণ্টা
  // ----------------------------------------------------------
  Widget _buildDayTiles(
      _WeatherData data, int sel, bool dark, Color titleColor, Color subColor) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: data.days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final day = data.days[i];
          final info = _infoFor(day.code);
          final selected = i == sel;

          return InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _selectDay(i),
            child: Container(
              width: 68,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: selected
                    ? (dark ? const Color(0xFF1E293B) : const Color(0xFFDCEFE2))
                    : (dark ? const Color(0xFF111C2E) : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected
                      ? (dark ? Colors.white : Colors.green[700]!)
                      : (dark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0)),
                  width: selected ? 1.6 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayShort(day.date),
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Icon(info.icon, size: 20, color: info.color),
                  const SizedBox(height: 5),
                  Text(
                    '${_tempText(day.max)}/${_tempText(day.min)}',
                    style: TextStyle(color: subColor, fontSize: 10.5),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // ছোট সহায়ক
  // ----------------------------------------------------------
  String _tempText(double? value) =>
      value == null ? '--' : '${_digits(value.round().toString())}°';

  double? _average(Iterable<double> values) {
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a + b) / values.length;
  }

  String _dayShort(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return '--';
    return (_isBn ? _bnDaysShort : _enDaysShort)[d.weekday - 1];
  }

  String _dayFullName(String date) {
    final d = DateTime.tryParse(date);
    if (d == null) return '--';
    return (_isBn ? _bnDaysFull : _enDaysFull)[d.weekday - 1];
  }
}

const List<String> _bnDaysShort = [
  'সোম',
  'মঙ্গল',
  'বুধ',
  'বৃহ',
  'শুক্র',
  'শনি',
  'রবি'
];
const List<String> _enDaysShort = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun'
];
const List<String> _bnDaysFull = [
  'সোমবার',
  'মঙ্গলবার',
  'বুধবার',
  'বৃহস্পতিবার',
  'শুক্রবার',
  'শনিবার',
  'রবিবার'
];
const List<String> _enDaysFull = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

// ==========================================================
// ডেটা মডেল
// ==========================================================
double _d(Object? v, [double fallback = 0]) =>
    v is num ? v.toDouble() : fallback;
double? _dn(Object? v) => v is num ? v.toDouble() : null;

class _DayForecast {
  final String date;
  final int code;
  final double? max;
  final double? min;

  const _DayForecast({
    required this.date,
    required this.code,
    required this.max,
    required this.min,
  });
}

class _Hour {
  final DateTime time;
  final double temp;
  final int code;
  final int pop; // বৃষ্টির সম্ভাবনা %
  final bool isDay;
  final double humidity;
  final double wind;

  const _Hour({
    required this.time,
    required this.temp,
    required this.code,
    required this.pop,
    required this.isDay,
    required this.humidity,
    required this.wind,
  });
}

class _WeatherData {
  final DateTime nowTime;
  final double temp;
  final double feelsLike;
  final double humidity;
  final double wind;
  final int code;
  final bool isDay;
  final List<_DayForecast> days;
  final List<_Hour> hours;

  const _WeatherData({
    required this.nowTime,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.wind,
    required this.code,
    required this.isDay,
    required this.days,
    required this.hours,
  });

  factory _WeatherData.fromJson(Map<String, dynamic> json) {
    final cur = json['current'] as Map<String, dynamic>;
    final daily = json['daily'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;

    // ---- দিনভিত্তিক ----
    final dTimes = (daily['time'] as List).cast<String>();
    final dCodes = daily['weather_code'] as List;
    final dMaxes = daily['temperature_2m_max'] as List;
    final dMins = daily['temperature_2m_min'] as List;

    final days = <_DayForecast>[];
    for (var i = 0; i < dTimes.length; i++) {
      days.add(
        _DayForecast(
          date: dTimes[i],
          code: _d(dCodes[i], -1).toInt(),
          max: _dn(dMaxes[i]),
          min: _dn(dMins[i]),
        ),
      );
    }
    if (days.isEmpty) throw const FormatException('no daily data');

    // ---- ঘণ্টাভিত্তিক ----
    final hTimes = (hourly['time'] as List).cast<String>();
    final hTemps = hourly['temperature_2m'] as List;
    final hCodes = hourly['weather_code'] as List;
    final hPop = hourly['precipitation_probability'] as List;
    final hDay = hourly['is_day'] as List;
    final hHum = hourly['relative_humidity_2m'] as List;
    final hWind = hourly['wind_speed_10m'] as List;

    final hours = <_Hour>[];
    for (var i = 0; i < hTimes.length; i++) {
      final t = DateTime.tryParse(hTimes[i]);
      if (t == null) continue;
      hours.add(
        _Hour(
          time: t,
          temp: _d(hTemps[i]),
          code: _d(hCodes[i], -1).toInt(),
          pop: _d(hPop[i]).round(),
          isDay: _d(hDay[i], 1) == 1,
          humidity: _d(hHum[i]),
          wind: _d(hWind[i]),
        ),
      );
    }

    final nowTime =
        DateTime.tryParse((cur['time'] as String?) ?? '') ?? DateTime.now();

    return _WeatherData(
      nowTime: nowTime,
      temp: _d(cur['temperature_2m']),
      feelsLike: _d(cur['apparent_temperature'], _d(cur['temperature_2m'])),
      humidity: _d(cur['relative_humidity_2m']),
      wind: _d(cur['wind_speed_10m']),
      code: _d(cur['weather_code'], -1).toInt(),
      isDay: _d(cur['is_day'], 1) == 1,
      days: days,
      hours: hours,
    );
  }

  // আজ (index 0) হলে এই ঘণ্টা থেকে পরের ২৪ ঘণ্টা;
  // অন্য দিন হলে সেই দিনের ০০:০০ থেকে ২৩:০০।
  List<_Hour> hoursFor(int dayIndex) {
    if (dayIndex == 0) {
      final startKey =
          DateTime(nowTime.year, nowTime.month, nowTime.day, nowTime.hour);
      final start = hours.indexWhere((h) => !h.time.isBefore(startKey));
      if (start < 0) return const [];
      return hours.skip(start).take(24).toList();
    }

    final d = DateTime.tryParse(days[dayIndex].date);
    if (d == null) return const [];
    return hours
        .where((h) =>
            h.time.year == d.year &&
            h.time.month == d.month &&
            h.time.day == d.day)
        .toList();
  }
}

// ==========================================================
// WMO weather code → আইকন + বর্ণনা (বাংলা/ইংরেজি)
// ==========================================================
class _WeatherInfo {
  final IconData icon;
  final Color color;
  final String bn;
  final String en;

  const _WeatherInfo(this.icon, this.color, this.bn, this.en);
}

_WeatherInfo _infoFor(int code, {bool isDay = true}) {
  const sun = Color(0xFFF59E0B);
  const night = Color(0xFF6366F1);
  const cloud = Color(0xFF64748B);
  const rain = Color(0xFF2563EB);
  const snow = Color(0xFF0EA5E9);
  const storm = Color(0xFF7C3AED);

  switch (code) {
    case 0:
      return isDay
          ? const _WeatherInfo(
              Icons.wb_sunny, sun, 'আকাশ পরিষ্কার', 'Clear sky')
          : const _WeatherInfo(
              Icons.nights_stay, night, 'আকাশ পরিষ্কার', 'Clear sky');
    case 1:
    case 2:
      return isDay
          ? const _WeatherInfo(
              Icons.wb_cloudy, sun, 'আংশিক মেঘলা', 'Partly cloudy')
          : const _WeatherInfo(
              Icons.nights_stay, night, 'আংশিক মেঘলা', 'Partly cloudy');
    case 3:
      return const _WeatherInfo(Icons.cloud, cloud, 'মেঘলা', 'Overcast');
    case 45:
    case 48:
      return const _WeatherInfo(Icons.blur_on, cloud, 'কুয়াশা', 'Fog');
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return const _WeatherInfo(
          Icons.grain, rain, 'গুঁড়িগুঁড়ি বৃষ্টি', 'Drizzle');
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
      return const _WeatherInfo(Icons.water_drop, rain, 'বৃষ্টি', 'Rain');
    case 71:
    case 73:
    case 75:
    case 77:
      return const _WeatherInfo(Icons.ac_unit, snow, 'তুষারপাত', 'Snow');
    case 80:
    case 81:
    case 82:
      return const _WeatherInfo(
          Icons.water_drop, rain, 'বৃষ্টির ঝাপটা', 'Rain showers');
    case 85:
    case 86:
      return const _WeatherInfo(
          Icons.ac_unit, snow, 'তুষারের ঝাপটা', 'Snow showers');
    case 95:
    case 96:
    case 99:
      return const _WeatherInfo(
          Icons.flash_on, storm, 'বজ্রসহ বৃষ্টি', 'Thunderstorm');
    default:
      return const _WeatherInfo(Icons.cloud, cloud, 'অজানা', 'Unknown');
  }
}

// ==========================================================
// অ্যানিমেটেড আকাশ — মেঘ, বৃষ্টি, তুষার, রোদ, চাঁদ-তারা, বজ্র
// (কোনো ছবি বা নতুন প্যাকেজ ছাড়া, শুধু CustomPainter)
// ==========================================================
enum _SceneKind { clear, partly, cloudy, fog, drizzle, rain, snow, storm }

_SceneKind _kindFor(int code) {
  switch (code) {
    case 0:
      return _SceneKind.clear;
    case 1:
    case 2:
      return _SceneKind.partly;
    case 3:
      return _SceneKind.cloudy;
    case 45:
    case 48:
      return _SceneKind.fog;
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return _SceneKind.drizzle;
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return _SceneKind.rain;
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return _SceneKind.snow;
    case 95:
    case 96:
    case 99:
      return _SceneKind.storm;
    default:
      return _SceneKind.cloudy;
  }
}

List<Color> _skyColors(_SceneKind kind, bool night) {
  if (night) {
    if (kind == _SceneKind.clear || kind == _SceneKind.partly) {
      return const [Color(0xFF0B1437), Color(0xFF22346E)];
    }
    if (kind == _SceneKind.storm) {
      return const [Color(0xFF14172B), Color(0xFF2E3250)];
    }
    return const [Color(0xFF1B2236), Color(0xFF39445F)];
  }
  if (kind == _SceneKind.clear) {
    return const [Color(0xFF3B82D6), Color(0xFF7DB8F0)];
  }
  if (kind == _SceneKind.partly) {
    return const [Color(0xFF4C8BD0), Color(0xFF8FBCE6)];
  }
  if (kind == _SceneKind.fog) {
    return const [Color(0xFF8A97A5), Color(0xFFB4BEC8)];
  }
  if (kind == _SceneKind.drizzle) {
    return const [Color(0xFF5C6B7F), Color(0xFF8493A6)];
  }
  if (kind == _SceneKind.rain) {
    return const [Color(0xFF3F4C60), Color(0xFF66768B)];
  }
  if (kind == _SceneKind.snow) {
    return const [Color(0xFF8EA2B7), Color(0xFFC0CDDA)];
  }
  if (kind == _SceneKind.storm) {
    return const [Color(0xFF2A2E43), Color(0xFF4A4F6C)];
  }
  return const [Color(0xFF6F7F94), Color(0xFF9AA9BB)]; // cloudy
}

class _SceneBackground extends StatefulWidget {
  final _SceneKind kind;
  final bool night;
  final Widget child;

  const _SceneBackground({
    required this.kind,
    required this.night,
    required this.child,
  });

  @override
  State<_SceneBackground> createState() => _SceneBackgroundState();
}

class _SceneBackgroundState extends State<_SceneBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ফোনে "অ্যানিমেশন বন্ধ" সেটিং থাকলে ছবিটা স্থির থাকবে।
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) => CustomPaint(
                  painter: _ScenePainter(_c.value, widget.kind, widget.night),
                ),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  final double t; // 0..1, ২৪ সেকেন্ডে একবার ঘোরে
  final _SceneKind kind;
  final bool night;

  const _ScenePainter(this.t, this.kind, this.night);

  // random নয়, নির্দিষ্ট অবস্থান — যাতে প্রতি ফ্রেমে ফোঁটা/তারা লাফিয়ে না যায়।
  static const List<double> _xs = [
    0.03,
    0.09,
    0.14,
    0.2,
    0.26,
    0.31,
    0.37,
    0.43,
    0.49,
    0.54,
    0.6,
    0.66,
    0.71,
    0.77,
    0.83,
    0.88,
    0.93,
    0.98,
    0.06,
    0.17,
    0.34,
    0.46,
    0.57,
    0.69,
    0.8,
    0.91,
    0.12,
    0.29,
    0.52,
    0.74,
    0.86,
    0.96
  ];
  static const List<double> _ys = [
    0.12,
    0.71,
    0.38,
    0.94,
    0.55,
    0.07,
    0.83,
    0.29,
    0.62,
    0.46,
    0.18,
    0.9,
    0.33,
    0.77,
    0.02,
    0.59,
    0.41,
    0.86,
    0.24,
    0.68,
    0.15,
    0.97,
    0.5,
    0.35,
    0.8,
    0.09,
    0.64,
    0.27,
    0.73,
    0.44,
    0.21,
    0.58
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final sky = _skyColors(kind, night);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: sky,
        ).createShader(rect),
    );

    final clearish = kind == _SceneKind.clear || kind == _SceneKind.partly;

    if (clearish) {
      if (night) {
        _stars(canvas, size);
        _moon(canvas, size);
      } else {
        _sun(canvas, size);
      }
    }

    switch (kind) {
      case _SceneKind.clear:
        break;
      case _SceneKind.partly:
        _clouds(canvas, size, 2,
            night ? const Color(0xCC6B7AA0) : const Color(0xE6FFFFFF));
        break;
      case _SceneKind.cloudy:
        _clouds(canvas, size, 4,
            night ? const Color(0xCC5A6684) : const Color(0xD9E3E8EE));
        break;
      case _SceneKind.fog:
        _fog(canvas, size);
        _clouds(canvas, size, 2, const Color(0x55FFFFFF));
        break;
      case _SceneKind.drizzle:
        _clouds(canvas, size, 3, const Color(0xE655657A));
        _rain(canvas, size, 14, 0.45, 7);
        break;
      case _SceneKind.rain:
        _clouds(canvas, size, 4, const Color(0xE62F3848));
        _rain(canvas, size, 30, 0.6, 11);
        break;
      case _SceneKind.snow:
        _clouds(canvas, size, 3, const Color(0xE6F1F5F9));
        _snow(canvas, size);
        break;
      case _SceneKind.storm:
        _clouds(canvas, size, 4, const Color(0xF0222838));
        _rain(canvas, size, 32, 0.65, 12);
        final ph = (t * 24) % 7.0;
        if (ph < 0.18) {
          canvas.drawRect(
            rect,
            Paint()
              ..color = Colors.white.withValues(alpha: 0.35 * (1 - ph / 0.18)),
          );
        }
        break;
    }
  }

  // সূর্য/চাঁদ ডানদিকের নিচে — লেখার সাথে যেন না মেশে।
  void _sun(Canvas canvas, Size size) {
    final c = Offset(size.width * 0.88, size.height * 0.74);
    final pulse = 1 + 0.06 * math.sin(2 * math.pi * t * 4);
    canvas.drawCircle(
      c,
      30 * pulse,
      Paint()
        ..color = const Color(0x33FFE082)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawCircle(c, 15, Paint()..color = const Color(0xFFFFD54F));
  }

  void _moon(Canvas canvas, Size size) {
    final c = Offset(size.width * 0.88, size.height * 0.74);
    canvas.drawCircle(
      c,
      26,
      Paint()
        ..color = const Color(0x22FFFFFF)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
    final full = Path()..addOval(Rect.fromCircle(center: c, radius: 14));
    final bite = Path()
      ..addOval(Rect.fromCircle(center: c + const Offset(7, -4), radius: 12));
    canvas.drawPath(
      Path.combine(PathOperation.difference, full, bite),
      Paint()..color = const Color(0xFFFFF3C4),
    );
  }

  void _stars(Canvas canvas, Size size) {
    final p = Paint();
    for (var i = 0; i < 22; i++) {
      final x = _xs[i] * size.width;
      final y = _ys[i] * size.height * 0.75;
      final tw = 0.45 +
          0.55 *
              (0.5 +
                  0.5 * math.sin(2 * math.pi * (t * (2 + i % 3) + i * 0.13)));
      p.color = Colors.white.withValues(alpha: tw);
      canvas.drawCircle(Offset(x, y), 0.9 + (i % 3) * 0.35, p);
    }
  }

  void _clouds(Canvas canvas, Size size, int count, Color color) {
    final span = size.width + 140;
    for (var i = 0; i < count; i++) {
      final base = (i * 0.37 + 0.1) * span;
      final speed = 1 + (i % 2); // পূর্ণসংখ্যা — লুপ নিখুঁতভাবে জোড়া লাগে
      final x = ((base + t * speed * span) % span) - 70;
      final y = size.height * (0.15 + 0.14 * (i % 4));
      _cloud(canvas, Offset(x, y), 0.9 + 0.2 * (i % 3), color);
    }
  }

  void _cloud(Canvas canvas, Offset o, double s, Color color) {
    final p = Paint()..color = color;
    canvas.drawCircle(o + Offset(-18 * s, 4 * s), 12 * s, p);
    canvas.drawCircle(o + Offset(-2 * s, -4 * s), 16 * s, p);
    canvas.drawCircle(o + Offset(16 * s, 2 * s), 12 * s, p);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: o + Offset(0, 8 * s),
          width: 52 * s,
          height: 14 * s,
        ),
        Radius.circular(7 * s),
      ),
      p,
    );
  }

  void _rain(Canvas canvas, Size size, int count, double alpha, double length) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: alpha)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < count; i++) {
      final k = 24 + (i % 4) * 4; // পূর্ণসংখ্যা গুণক — ফোঁটা ~১ সেকেন্ডে পড়ে
      final prog = (_ys[i] + t * k) % 1.0;
      final y = prog * (size.height + 20) - 10;
      final x = _xs[i] * size.width - prog * 6;
      canvas.drawLine(Offset(x, y), Offset(x - 3, y + length), p);
    }
  }

  void _snow(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.85);
    for (var i = 0; i < 26; i++) {
      final k = 3 + (i % 3);
      final prog = (_ys[i] + t * k) % 1.0;
      final y = prog * (size.height + 10) - 5;
      final x = _xs[i] * size.width +
          math.sin(2 * math.pi * (t * (2 + i % 2) + i * 0.2)) * 6;
      canvas.drawCircle(Offset(x, y), 1.4 + (i % 3) * 0.6, p);
    }
  }

  void _fog(Canvas canvas, Size size) {
    final span = size.width + 200;
    for (var i = 0; i < 3; i++) {
      final x = ((i * 0.33 * span + t * span) % span) - 200;
      final y = size.height * (0.25 + 0.25 * i);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, 220, 16),
          const Radius.circular(8),
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ScenePainter old) =>
      old.t != t || old.kind != kind || old.night != night;
}
