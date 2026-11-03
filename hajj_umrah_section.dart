import 'hajj_step_by_step_section.dart';
import 'hajj_group_section.dart';
import 'hajj_visual_section.dart';
import 'hajj_masala_section.dart';
import 'rawdah_amal_section.dart';
import 'dua_section.dart';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'cities_data.dart';
import 'prayer_times.dart';
import 'makkah_bg_data.dart';
import 'hajj_regulations_section.dart';

// ==========================================================
// মক্কা — cities_data.dart-এর worldCities তালিকায় আগে থেকেই আছে,
// তাই নতুন করে না বানিয়ে ওখান থেকেই নেওয়া হলো।
// ==========================================================
final CityLocation _makkahCity =
    worldCities.firstWhere((c) => c.nameEnglish == 'Makkah');

// ==========================================================
// সময়ের স্ট্রিং (যেমন "05:12 PM") থেকে দিনের মিনিট-সংখ্যা বের করে —
// এখন কোন ওয়াক্ত চলছে সেটা বের করতে ব্যবহার হয়।
// ==========================================================
int? _parseTimeToMinutes(String value) {
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

class HajjUmrahSection extends StatefulWidget {
  final CityLocation selectedCity;

  const HajjUmrahSection({super.key, required this.selectedCity});

  @override
  State<HajjUmrahSection> createState() => _HajjUmrahSectionState();
}

class _HajjUmrahSectionState extends State<HajjUmrahSection> {
  Timer? _timer;

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
    // প্রতি সেকেন্ডে ঘড়ি রিফ্রেশ হবে
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ==========================================================
  // মক্কার সময় — সৌদি আরবের fixed timezone UTC+3 (কোনো DST নেই)
  // ব্যবহার করে বের করা হয়, কারণ CityLocation-এ timezone তথ্য নেই।
  // ==========================================================
  DateTime _makkahTime() {
    return DateTime.now().toUtc().add(const Duration(hours: 3));
  }

  String _formatClock(DateTime dt) {
    int hour12 = dt.hour % 12;
    if (hour12 == 0) hour12 = 12;
    final h = hour12.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    // ঘড়ির সংখ্যা ইংরেজি সংখ্যায় রাখা হলো (বাংলা রূপান্তর ছাড়া)
    return '$h:$m:$s $period';
  }

  String _formatDateLabel(DateTime dt) {
    final weekday = _banglaWeekdays[dt.weekday - 1];
    // তারিখের সংখ্যা ইংরেজিতে, মাস/বার বাংলা নামেই থাকছে
    return '$weekday, ${dt.day} ${_banglaMonths[dt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // widget.selectedCity-এর সময় হিসেবে ডিভাইসের নিজস্ব সময় ব্যবহার
    // করা হচ্ছে — যেহেতু CityLocation-এ timezone তথ্য নেই, এবং ধরে
    // নেওয়া হচ্ছে ব্যবহারকারী সত্যিই নির্বাচিত শহরে অবস্থান করছেন।
    final localNow = DateTime.now();
    final makkahNow = _makkahTime();

    // মক্কার নামাজের সময়সূচি — মক্কার স্থানাঙ্ক ব্যবহার করে
    final makkahPrayerTimes = calculatePrayerTimes(
      _makkahCity.lat,
      _makkahCity.lng,
      method: 'UmmAlQura',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(isDark, localNow, makkahNow),
        const SizedBox(height: 16),
        _buildMakkahPrayerTimesCard(isDark, makkahPrayerTimes, makkahNow),
        const SizedBox(height: 20),
        _sectionTitle('সকল বিভাগ', isDark),
        const SizedBox(height: 10),
        _buildCategoryList(context, isDark),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderBanner(
      bool isDark, DateTime localNow, DateTime makkahNow) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          // ব্যাকগ্রাউন্ড — মক্কার ছবি, makkah_bg_data.dart ফাইলে base64
          // হিসেবে এমবেড করা আছে। কোনো assets ফোল্ডার, pubspec.yaml এডিট,
          // বা internet কানেকশনের দরকার নেই — অফলাইনেও কাজ করবে।
          Positioned.fill(
            child: Image.memory(
              base64Decode(makkahBgBase64),
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF064E3B), Color(0xFF0F2E2A)],
                    ),
                  ),
                );
              },
            ),
          ),
          // টেক্সট পড়তে সুবিধার জন্য গাঢ় gradient overlay — উপরে
          // হালকা, নিচে গাঢ়, যাতে ছবি দেখাও যায় আবার লেখাও পড়া যায়
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.45),
                    Colors.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text('🕋', style: TextStyle(fontSize: 22)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'হজ্জ ও উমরা গাইড',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'মুসলিম বাংলা',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _clockCard(
                        flag: '📍',
                        label: widget.selectedCity.nameBangla,
                        time: _formatClock(localNow),
                        date: _formatDateLabel(localNow),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _clockCard(
                        flag: '🕋',
                        label: 'মক্কা',
                        time: _formatClock(makkahNow),
                        date: _formatDateLabel(makkahNow),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _clockCard({
    required String flag,
    required String label,
    required String time,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            date,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // মক্কার সময় অনুযায়ী (স্থানীয় সময় না) এই মুহূর্তে কোন ওয়াক্ত
  // চলছে সেটা বের করে — পরের ওয়াক্ত শুরুর আগ পর্যন্ত বর্তমানটাই
  // সক্রিয় ধরা হয়। ইশার জন্য মধ্যরাত পার হয়ে ফজর পর্যন্ত হিসাব।
  // ==========================================================
  int _getCurrentMakkahWaqtIndex(PrayerTimesData pt, DateTime makkahNow) {
    final nowMin = makkahNow.hour * 60 + makkahNow.minute;
    final times = [pt.fajr, pt.dhuhr, pt.asr, pt.maghrib, pt.isha];
    final starts = times.map(_parseTimeToMinutes).toList();

    for (int i = 0; i < starts.length; i++) {
      final start = starts[i];
      if (start == null) continue;
      final end = (i < starts.length - 1) ? starts[i + 1] : starts[0];
      if (end == null) continue;

      if (i == starts.length - 1) {
        // ইশা — মধ্যরাত পার হয়ে ফজর পর্যন্ত
        if (nowMin >= start || nowMin < end) return i;
      } else if (nowMin >= start && nowMin < end) {
        return i;
      }
    }
    return -1;
  }

  Widget _buildMakkahPrayerTimesCard(
    bool isDark,
    PrayerTimesData pt,
    DateTime makkahNow,
  ) {
    final items = [
      {'label': 'ফজর', 'icon': '🌙', 'time': pt.fajr},
      {'label': 'যুহর', 'icon': '☀️', 'time': pt.dhuhr},
      {'label': 'আসর', 'icon': '⛅', 'time': pt.asr},
      {'label': 'মাগরিব', 'icon': '🌇', 'time': pt.maghrib},
      {'label': 'ইশা', 'icon': '🕌', 'time': pt.isha},
    ];

    final currentIndex = _getCurrentMakkahWaqtIndex(pt, makkahNow);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFE8ECEA),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            'মক্কার নামাজের সময়সূচি',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F2E2A),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isCurrent = index == currentIndex;

              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.green[700] : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Text(item['icon'] as String,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.white
                              : Colors.green[isDark ? 300 : 700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['time'] as String, // ইংরেজি সংখ্যায়ই রাখা হলো
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black87),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'এখন',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  // ==========================================================
  // "সকল বিভাগ" লিস্ট — প্রথমটা (ধাপে ধাপে হজ্জ গাইড) একটু আলাদা
  // highlighted card হিসেবে, বাকিগুলো একটা card-এর ভিতরে stacked।
  // কনটেন্ট এখনো তৈরি হয়নি বলে ট্যাপ করলে "শীঘ্রই আসছে" snackbar
  // দেখাবে — পরে আসল পেজ বানানো হলে Navigator.push বসিয়ে দিতে হবে।
  // ==========================================================
  Widget _buildCategoryList(BuildContext context, bool isDark) {
    final categories = [
      {
        'title': 'ধাপে ধাপে হজ্জ গাইড',
        'subtitle': 'আমলের ধারাবাহিক তালিকা ও চেকলিস্ট',
        'icon': '✅',
        'badge': 'চেকলিস্ট',
      },
      {
        'title': 'বিধিমালা',
        'subtitle': 'অনুমোদিত, অননুমোদিত, দম ও সদকার...',
        'icon': '📖',
      },
      {
        'title': 'হজ্জ গ্রুপ',
        'subtitle': 'মুফতি ও হাজ্জীদের সাথে সরাসরি কথা...',
        'icon': '💬',
        'badge': 'লাইভ',
      },
      {
        'title': 'সচিত্র হজ্জ',
        'subtitle': 'ম্যাপ ও ছবিসহ হজ্জের প্রতিটি স্থান',
        'icon': '🗺️',
        'badge': 'ছবি',
      },
      {
        'title': 'মাসআলা',
        'subtitle': 'হজ্জ সংক্রান্ত গুরুত্বপূর্ণ মাসআলা-মাসায়েল',
        'icon': '❓',
      },
      {
        'title': 'রওজার আমল',
        'subtitle': 'মদিনায় রওজা মোবারক জিয়ারতের আমল',
        'icon': '🤍',
      },
      {
        'title': 'দোয়া সমূহ',
        'subtitle': 'হজ্জ, উমরা ও সফরের সকল দোয়া',
        'icon': '📿',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // প্রথম item — আলাদা highlighted card
        _categoryCard(context, categories[0], isDark, highlighted: true),
        const SizedBox(height: 12),
        // বাকি items — একটা card-এর ভিতরে stacked, মাঝে Divider
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: List.generate(categories.length - 1, (i) {
              final item = categories[i + 1];
              return Column(
                children: [
                  _categoryRow(context, item, isDark),
                  if (i < categories.length - 2)
                    Divider(
                      height: 1,
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFE2E8F0),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // "বিধিমালা"-তে ট্যাপ করলে আসল পেজে নিয়ে যায় (hajj_regulations_
  // section.dart) — বাকি ক্যাটাগরিগুলোর কনটেন্ট এখনো তৈরি হয়নি
  // বলে "শীঘ্রই আসছে" snackbar-ই দেখায়।
  // ==========================================================
  void _onCategoryTap(BuildContext context, String title) {
    Widget? page;

    switch (title) {
      case 'বিধিমালা':
        page = const HajjRegulationsSection();
        break;
      case 'ধাপে ধাপে হজ্জ গাইড':
        page = const HajjStepByStepSection();
        break;
      case 'হজ্জ গ্রুপ':
        page = const HajjGroupSection();
        break;
      case 'সচিত্র হজ্জ':
        page = const HajjVisualSection();
        break;
      case 'মাসআলা':
        page = const HajjMasalaSection();
        break;
      case 'রওজার আমল':
        page = const RawdahAmalSection();
        break;
      case 'দোয়া সমূহ':
        page = const DuaSection();
        break;
    }

    if (page != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => page!),
      );
    }
  }

  Widget _categoryCard(
    BuildContext context,
    Map<String, String> item,
    bool isDark, {
    bool highlighted = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _onCategoryTap(context, item['title']!),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: highlighted
                ? Colors.green[700]!
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            width: highlighted ? 1.6 : 1,
          ),
        ),
        child: _categoryContent(item, isDark),
      ),
    );
  }

  Widget _categoryRow(
      BuildContext context, Map<String, String> item, bool isDark) {
    return InkWell(
      onTap: () => _onCategoryTap(context, item['title']!),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: _categoryContent(item, isDark),
      ),
    );
  }

  Widget _categoryContent(Map<String, String> item, bool isDark) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F1),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(item['icon'] ?? '', style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      item['title'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.green[isDark ? 300 : 800],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (item['badge'] != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item['badge']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                item['subtitle'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right,
          color: isDark ? Colors.grey[500] : Colors.grey[400],
        ),
      ],
    );
  }
}
