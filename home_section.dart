import 'weather_card.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'prayer_times.dart';
import 'cities_data.dart';
import 'nafl_times.dart';
import 'prayer_arc_card.dart';
import 'qibla.dart';
import 'qibla_section.dart';
import 'quran_data.dart';
import 'quran_section.dart';
import 'azan_notification_service.dart';

class HomeSection extends StatefulWidget {
  final PrayerTimesData prayerTimes;
  final CityLocation selectedCity;
  final void Function(String tab) setActiveTab;
  final Future<void> Function()? onMuteChanged;

  const HomeSection({
    super.key,
    required this.prayerTimes,
    required this.selectedCity,
    required this.setActiveTab,
    this.onMuteChanged,
  });

  @override
  State<HomeSection> createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  Timer? _timer;
  bool _isPrayerListExpanded = false;
  Map<String, String> prayerVoiceChoices = {};

  static const List<String> _banglaWeekdays = [
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার'
  ];
  static const List<String> _banglaMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর'
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
    _loadPrayerVoiceChoices();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerVoiceChoices() async {
    final choices =
        await AzanNotificationService.instance.getPrayerVoiceChoices();
    if (mounted) setState(() => prayerVoiceChoices = choices);
  }

  Future<void> _setPrayerVoiceChoice(String key, String voiceId) async {
    setState(() {
      prayerVoiceChoices = {...prayerVoiceChoices, key: voiceId};
    });
    await AzanNotificationService.instance.setPrayerVoiceChoice(key, voiceId);
    await widget.onMuteChanged?.call();
  }

  List<Map<String, String>> get _forojoPrayersList {
    final isFriday = isJumuahDay;
    return [
      {
        'key': 'fajr',
        'nameBangla': 'ফজর',
        'time': widget.prayerTimes.fajr,
        'endTime': widget.prayerTimes.sunrise,
        'desc': 'ভোরের সালাত • ২ রাকাত ফরজ',
      },
      {
        'key': 'dhuhr',
        'nameBangla': isFriday ? 'জুম\'আ' : 'যোহর',
        'time': widget.prayerTimes.dhuhr,
        'endTime': widget.prayerTimes.asr,
        'desc': isFriday
            ? 'জুমার নামায • ২ রাকাত ফরজ (খুতবাসহ)'
            : 'দ্বিপ্রহরের সালাত • ৪ রাকাত ফরজ',
      },
      {
        'key': 'asr_shafi',
        'nameBangla': 'আসর (শাফেয়ী)',
        'time': widget.prayerTimes.asr,
        'endTime': widget.prayerTimes.maghrib,
        'desc': 'অপরাহ্ণের সালাত • ৪ রাকাত ফরজ',
      },
      {
        'key': 'asr_hanafi',
        'nameBangla': 'আসর (হানাফি)',
        'time': widget.prayerTimes.asrHanafi,
        'endTime': widget.prayerTimes.maghrib,
        'desc': 'অপরাহ্ণের সালাত • ৪ রাকাত ফরজ (হানাফি মাযহাব)',
      },
      {
        'key': 'maghrib',
        'nameBangla': 'মাগরিব',
        'time': widget.prayerTimes.maghrib,
        'endTime': widget.prayerTimes.isha,
        'desc': 'সূর্যাস্তের সালাত • ৩ রাকাত ফরজ',
      },
      {
        'key': 'isha',
        'nameBangla': 'এশা',
        'time': widget.prayerTimes.isha,
        'endTime': widget.prayerTimes.fajr,
        'desc': 'রাত্রিকালীন সালাত • ৪ রাকাত ফরজ',
      },
    ];
  }

  void _openVoicePickerFor(String key, String nameBangla, bool dark) {
    final currentChoice =
        prayerVoiceChoices[key] ?? AzanNotificationService.defaultAzanVoiceId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            '$nameBangla — আজান বাছাই করুন',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _voiceOptionTile(
                  label: 'নিরব (মিউট)',
                  isSelected:
                      currentChoice == AzanNotificationService.muteValue,
                  dark: dark,
                  onTap: () {
                    Navigator.of(context).pop();
                    _setPrayerVoiceChoice(
                        key, AzanNotificationService.muteValue);
                  },
                ),
                ...azanVoiceOptions.map(
                  (voice) => _voiceOptionTile(
                    label: voice.labelBangla,
                    isSelected: currentChoice == voice.id,
                    dark: dark,
                    onTap: () {
                      Navigator.of(context).pop();
                      _setPrayerVoiceChoice(key, voice.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('বাতিল'),
            ),
          ],
        );
      },
    );
  }

  Widget _voiceOptionTile({
    required String label,
    required bool isSelected,
    required bool dark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected ? Colors.green[600] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final hijri = HijriCalendar.fromDate(now);
    final hijriStr =
        '${bnNum(hijri.hDay)} ${hijri.longMonthName} ${bnNum(hijri.hYear)} হিজরি';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTodayCard(dark, now, hijriStr),
        const SizedBox(height: 10),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _isPrayerListExpanded = !_isPrayerListExpanded;
            });
          },
          child: PrayerArcCard(
            prayerTimes: widget.prayerTimes,
            isDarkTheme: dark,
          ),
        ),
        if (_isPrayerListExpanded) ...[
          const SizedBox(height: 10),
          ..._forojoPrayersList.map((p) => _forojoRow(p, dark)),
          const SizedBox(height: 14),
          _buildNaflSection(dark),
          const SizedBox(height: 14),
          _buildForbiddenTimesSection(dark),
          const SizedBox(height: 14),
          _buildQiblaPreviewSection(dark),
        ],
        const SizedBox(height: 12),
        _buildSadaqaBanner(dark),
        if (!_isPrayerListExpanded) ...[
          const SizedBox(height: 14),
          _buildIlmHeader(dark),
          const SizedBox(height: 10),
          _buildIlmGrid(dark),
          const SizedBox(height: 12),
          _buildDailyAyatCard(dark),
          const SizedBox(height: 12),
          WeatherCard(selectedCity: widget.selectedCity),
        ],
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildTodayCard(bool dark, DateTime now, String hijriStr) {
    final weekday = _banglaWeekdays[now.weekday - 1];
    final dateStr =
        '$weekday, ${bnNum(now.day)} ${_banglaMonths[now.month - 1]} ${bnNum(now.year)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: dark ? Colors.grey[900]?.withValues(alpha: 0.6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: dark ? Colors.grey[700]! : const Color(0xFFE1E6E4)),
      ),
      child: Column(
        children: [
          Text(
            hijriStr,
            style: TextStyle(
              color: dark ? Colors.white : const Color(0xFF0F2E2A),
              fontWeight: FontWeight.bold,
              fontSize: 14.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            dateStr,
            style: TextStyle(
                color: dark ? Colors.grey[300] : Colors.grey[700],
                fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // এই মুহূর্তে কোন ফরজ ওয়াক্ত চলছে সেটা বের করে — এশার জন্য
  // মধ্যরাত পার হয়ে যাওয়ার হিসাবও রাখা হয়েছে।
  // ==========================================================
  String? _getCurrentForojoKey() {
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;

    for (final p in _forojoPrayersList) {
      final start = _parseTimeStr(p['time']!);
      final end = _parseTimeStr(p['endTime']!);
      if (start == null || end == null) continue;

      if (p['key'] == 'isha') {
        if (nowMin >= start || nowMin < end) return p['key'];
      } else if (nowMin >= start && nowMin < end) {
        return p['key'];
      }
    }
    return null;
  }

  Widget _forojoRow(Map<String, String> p, bool dark) {
    final key = p['key']!;
    final currentChoice =
        prayerVoiceChoices[key] ?? AzanNotificationService.defaultAzanVoiceId;
    final isMuted = currentChoice == AzanNotificationService.muteValue;
    final isCurrent = _getCurrentForojoKey() == key;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent
            ? (dark
                ? Colors.green[900]?.withValues(alpha: 0.55)
                : Colors.green[50])
            : (dark ? Colors.grey[900]?.withValues(alpha: 0.5) : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent
              ? Colors.green
              : (dark ? Colors.grey[700]! : const Color(0xFFE1E6E4)),
          width: isCurrent ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      p['nameBangla']!,
                      style: TextStyle(
                        color: dark ? Colors.white : const Color(0xFF0F2E2A),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'এখন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  p['desc']!,
                  style: TextStyle(
                      color: dark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            '${bnTime(p['time']!)} - ${bnTime(p['endTime']!)}',
            style: TextStyle(
              color: isCurrent
                  ? (dark ? Colors.greenAccent : Colors.green[700])
                  : Colors.green[dark ? 300 : 700],
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _openVoicePickerFor(key, p['nameBangla']!, dark),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isMuted ? Colors.grey[850] : Colors.green[950],
                border: Border.all(
                  color: isMuted ? Colors.grey[600]! : Colors.green[600]!,
                  width: 1.5,
                ),
              ),
              child: Icon(
                isMuted
                    ? Icons.notifications_off_outlined
                    : Icons.notifications_active,
                size: 15,
                color: isMuted ? Colors.grey[400] : Colors.green[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // নফল নামায — তাহাজ্জুদ, ইশরাক, চাশত, যাওয়াল, আউয়াবীন — ৫টা কার্ড,
  // পাশাপাশি স্ক্রল করা যায়, বর্তমানে চলমানটা রঙিন বর্ডারে হাইলাইট।
  // ==========================================================
  Widget _buildNaflSection(bool dark) {
    final nafl = calculateNaflTimes(widget.prayerTimes);
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;

    final items = [
      {
        'title': 'তাহাজ্জুদ',
        'icon': Icons.nightlight_round,
        'start': '--:--',
        'end': bnTime(widget.prayerTimes.fajr),
        'rawStart': null,
        'rawEnd': widget.prayerTimes.fajr,
        'color': const Color(0xFF6A1B9A),
      },
      {
        'title': 'ইশরাক',
        'icon': Icons.wb_twilight,
        'start': bnTime(nafl.ishraqStart),
        'end': bnTime(nafl.ishraqEnd),
        'rawStart': nafl.ishraqStart,
        'rawEnd': nafl.ishraqEnd,
        'color': const Color(0xFFF9A825),
      },
      {
        'title': 'চাশত',
        'icon': Icons.wb_cloudy,
        'start': bnTime(nafl.chashtStart),
        'end': bnTime(nafl.chashtEnd),
        'rawStart': nafl.chashtStart,
        'rawEnd': nafl.chashtEnd,
        'color': const Color(0xFF00897B),
      },
      {
        'title': 'যাওয়াল',
        'icon': Icons.wb_sunny,
        'start': bnTime(nafl.zawalTime),
        'end': '--:--',
        'rawStart': nafl.zawalTime,
        'rawEnd': null,
        'color': const Color(0xFFB8860B),
      },
      {
        'title': 'আউয়াবীন',
        'icon': Icons.nights_stay,
        'start': bnTime(widget.prayerTimes.maghrib),
        'end': bnTime(widget.prayerTimes.isha),
        'rawStart': widget.prayerTimes.maghrib,
        'rawEnd': widget.prayerTimes.isha,
        'color': const Color(0xFF1565C0),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'নফল নামায',
                  style: TextStyle(
                    color: dark ? Colors.white : const Color(0xFF0F2E2A),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'আরও দেখুন',
                  style: TextStyle(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right,
                    size: 16,
                    color: dark ? Colors.grey[400] : Colors.grey[600]),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = items[index];
              final itemColor = item['color'] as Color;

              final rawStart = item['rawStart'] as String?;
              final rawEnd = item['rawEnd'] as String?;
              bool isActive = false;
              if (rawStart != null && rawEnd != null) {
                final s = _parseTimeStr(rawStart);
                final e = _parseTimeStr(rawEnd);
                if (s != null && e != null && e > s) {
                  isActive = nowMin >= s && nowMin < e;
                }
              }

              return Container(
                width: 112,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive
                        ? itemColor
                        : (dark
                            ? const Color(0xFF1E293B)
                            : itemColor.withValues(alpha: 0.25)),
                    width: isActive ? 1.6 : 1,
                  ),
                  boxShadow: dark
                      ? null
                      : [
                          BoxShadow(
                            color: itemColor.withValues(alpha: 0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: itemColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item['icon'] as IconData,
                          size: 17, color: itemColor),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item['title'] as String,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: dark ? Colors.white : const Color(0xFF0F2E2A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item['start'] as String,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: dark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                    Text(
                      item['end'] as String,
                      style: TextStyle(
                          fontSize: 10.5,
                          color: dark ? Colors.grey[500] : Colors.grey[500]),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int? _parseTimeStr(String value) {
    try {
      final cleaned = value.trim().toLowerCase();
      final isPm = cleaned.contains('pm');
      final isAm = cleaned.contains('am');
      final numbers = RegExp(r'\d+')
          .allMatches(cleaned)
          .map((m) => int.parse(m.group(0)!))
          .toList();
      if (numbers.length < 2) return null;
      int hour = numbers[0];
      final minute = numbers[1];
      if (isPm && hour < 12) hour += 12;
      if (isAm && hour == 12) hour = 0;
      if (hour > 23 || minute > 59) return null;
      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  // ==========================================================
  // নামাযের নিষিদ্ধ সময় — prayer_times.dart-এর সঠিক
  // calculateForbiddenTimes() থেকে সময়ের রেঞ্জ নিয়ে।
  // ==========================================================
  Widget _buildForbiddenTimesSection(bool dark) {
    final forbiddenTimes = calculateForbiddenTimes(widget.prayerTimes);
    final icons = [
      Icons.wb_twilight,
      Icons.wb_sunny,
      Icons.nightlight_round,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'নামাযের নিষিদ্ধ সময়',
                  style: TextStyle(
                    color: dark ? Colors.red[200] : Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'আরও দেখুন',
                  style: TextStyle(
                    color: dark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.chevron_right,
                    size: 16,
                    color: dark ? Colors.grey[400] : Colors.grey[600]),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: forbiddenTimes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final ft = forbiddenTimes[index];
              final icon = icons[index % icons.length];
              return Container(
                width: 168,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      dark ? const Color(0xFF3B1414) : const Color(0xFFFBEAEA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: dark
                        ? const Color(0xFF5C1F1F)
                        : const Color(0xFFF3B6B6),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: dark ? 0.15 : 0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon,
                          size: 17,
                          color: dark ? Colors.red[200] : Colors.red[400]),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ft.label,
                            style: TextStyle(
                              color:
                                  dark ? Colors.white : const Color(0xFF7F1D1D),
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${bnTime(ft.start)} - ${bnTime(ft.end)}',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: dark ? Colors.grey[300] : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // কিবলা — prayer_section.dart-এর সঠিক calculateQibla() ব্যবহার
  // করে দূরত্ব ও অভিমুখ দেখায়, বাটনে চাপলে আসল QiblaSection (সেন্সর
  // সহ কম্পাস) পেজে নিয়ে যায়।
  // ==========================================================
  Widget _buildQiblaPreviewSection(bool dark) {
    final qiblaData = calculateQibla(
      widget.selectedCity.lat,
      widget.selectedCity.lng,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? Colors.grey[900]?.withValues(alpha: 0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: dark ? Colors.grey[700]! : const Color(0xFFE1E6E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.explore, color: Colors.amber, size: 17),
              const SizedBox(width: 6),
              Text(
                'কিবলা কম্পাস',
                style: TextStyle(
                  color: dark ? Colors.white : const Color(0xFF0F2E2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'কাবার দূরত্ব',
                      style: TextStyle(
                        color:
                            dark ? Colors.grey[400] : const Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${bnNum(qiblaData.distanceKm.round())} কি.মি.',
                      style: TextStyle(
                        color: dark ? Colors.white : const Color(0xFF0F2E2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'উত্তর দিক থেকে অভিমুখ',
                      style: TextStyle(
                        color:
                            dark ? Colors.grey[400] : const Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${bnNum(qiblaData.qiblaBearing.round())}°',
                      style: TextStyle(
                        color: dark ? Colors.white : const Color(0xFF0F2E2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QiblaSection(
                      selectedCity: widget.selectedCity,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.navigation_outlined, size: 16),
              label: const Text(
                'কিবলা কম্পাস বিস্তারিত',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSadaqaBanner(bool dark) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () =>
          widget.setActiveTab('seba'), // TODO: কনফার্ম করো — সঠিক ট্যাব আইডি
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: dark
              ? Colors.brown[900]?.withValues(alpha: 0.3)
              : const Color(0xFFFBEFE0),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.volunteer_activism, color: Colors.orange[700], size: 26),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'জুমার দিনের সদকা',
                    style: TextStyle(
                      color: dark ? Colors.white : const Color(0xFF5C3A17),
                      fontWeight: FontWeight.bold,
                      fontSize: 12.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'অন্যান্য সকল দিনের তুলনায় অধিকতর মর্যাদাপূর্ণ',
                    style: TextStyle(
                        color: dark ? Colors.white70 : Colors.brown[400],
                        fontSize: 10),
                  ),
                ],
              ),
            ),
            Text(
              'দান করুন',
              style: TextStyle(
                  color: Colors.green[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIlmHeader(bool dark) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: Colors.green[700]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'ইলম',
            style: TextStyle(
              color: dark ? Colors.white : const Color(0xFF0F2E2A),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: const Icon(Icons.search, color: Colors.white, size: 16),
        ),
      ],
    );
  }

  // ==========================================================
  // "আমল" ট্যাবের হুবহু স্টাইলে — ইমোজি আইকন (Material Icon না),
  // একই কার্ড ডিজাইন, একই টেক্সট স্টাইল।
  // ==========================================================
  Widget _buildIlmGrid(bool dark) {
    final items = [
      {'label': 'কুরআন', 'icon': '📖', 'tab': 'quran'},
      {'label': 'কিতাব', 'icon': '📚', 'tab': 'boyan'},
      {'label': 'হাদীস', 'icon': '📜', 'tab': 'hadith'},
      {'label': 'প্রবন্ধ', 'icon': '✍️', 'tab': 'bibidh'},
      {'label': 'বয়ান', 'icon': '🎙️', 'tab': 'boyan'},
      {'label': 'কুরআন শিক্ষা', 'icon': '🎓', 'tab': 'quran'},
      {'label': 'নামায শিক্ষা', 'icon': '🕌', 'tab': 'namaz'},
      {'label': 'দু\'আ ও জিকির', 'icon': '🤲', 'tab': 'dua'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => widget.setActiveTab(item['tab'] as String),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: dark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color:
                      dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['icon'] as String,
                    style: const TextStyle(fontSize: 19)),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyAyatCard(bool dark) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _openAyatulKursi(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: dark
              ? Colors.amber[900]?.withValues(alpha: 0.15)
              : const Color(0xFFFFF7E6),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber[700], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'দৈনিক আয়াত - আয়াতুল কুরসী',
                style: TextStyle(
                  color: dark ? Colors.white : const Color(0xFF5C3A17),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: dark ? Colors.white54 : Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // আয়াতুল কুরসী (সূরা আল-বাকারা, আয়াত ২৫৫) — নিজের কোনো টেক্সট না
  // দেখিয়ে সরাসরি আসল SurahReaderPage-এ (API থেকে আসা প্রকৃত আরবি +
  // বাংলা অনুবাদ + অডিওসহ) সংশ্লিষ্ট আয়াতের কাছে স্ক্রল করে নিয়ে যায়।
  // ==========================================================
  void _openAyatulKursi(BuildContext context) {
    final surah = surahsList.firstWhere((s) => s.number == 2);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SurahReaderPage(
          surah: surah,
          initialAyahNumber: 255,
          showOnlyInitialAyah: true,
        ),
      ),
    );
  }
}
