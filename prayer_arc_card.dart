import 'dart:async';
import 'package:flutter/material.dart';
import 'prayer_times.dart';
import 'nafl_times.dart';

/// সাহরি শেষ → ইশরাক → ইফতার — dome/arc আকৃতির visual card,
/// নিচে বর্তমান ওয়াক্তের progress bar + countdown সহ।
/// isDarkTheme অনুযায়ী light/dark দুই রূপেই দেখাতে পারে।
class PrayerArcCard extends StatefulWidget {
  final PrayerTimesData prayerTimes;
  final bool isDarkTheme;

  const PrayerArcCard({
    super.key,
    required this.prayerTimes,
    this.isDarkTheme = false,
  });

  @override
  State<PrayerArcCard> createState() => _PrayerArcCardState();
}

class _PrayerArcCardState extends State<PrayerArcCard> {
  Timer? _timer;
  bool _showAltLabels = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int? _parseTime(String value) {
    try {
      final cleaned = value.trim().toLowerCase();
      final isPm = cleaned.contains('pm') || cleaned.contains('p.m');
      final isAm = cleaned.contains('am') || cleaned.contains('a.m');

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

  // ফিক্স: শুক্রবারে "যোহর"-এর জায়গায় "জুম'আ" দেখানো হচ্ছে,
  // prayer_section.dart-এর ফরজ নামায লিস্টের সাথে সামঞ্জস্যপূর্ণ রাখতে।
  List<Map<String, String>> get _prayersList {
    final isFriday = isJumuahDay;

    return [
      {
        'nameBangla': 'ফজর',
        'key': 'fajr',
        'time': widget.prayerTimes.fajr,
        'endTime': widget.prayerTimes.sunrise,
      },
      {
        'nameBangla': isFriday ? 'জুম\'আ' : 'যোহর',
        'key': 'dhuhr',
        'time': widget.prayerTimes.dhuhr,
        'endTime': widget.prayerTimes.asr,
      },
      {
        'nameBangla': 'আসর',
        'key': 'asr',
        'time': widget.prayerTimes.asr,
        'endTime': widget.prayerTimes.maghrib,
      },
      {
        'nameBangla': 'মাগরিব',
        'key': 'maghrib',
        'time': widget.prayerTimes.maghrib,
        'endTime': widget.prayerTimes.isha,
      },
      {
        'nameBangla': 'এশা',
        'key': 'isha',
        'time': widget.prayerTimes.isha,
        'endTime': widget.prayerTimes.fajr,
      },
    ];
  }

  Map<String, String>? _currentPrayer(int nowMin) {
    for (final p in _prayersList) {
      final start = _parseTime(p['time']!);
      final end = _parseTime(p['endTime']!);
      if (start == null || end == null) continue;

      if (p['key'] == 'isha') {
        if (nowMin >= start || nowMin < end) return p;
      } else if (nowMin >= start && nowMin < end) {
        return p;
      }
    }
    return null;
  }

  // ফরজের ফাঁকা সময়ে (যেমন সূর্যোদয় থেকে যোহরের মধ্যে) কোনো নফল সময়
  // (ইশরাক/চাশত) চলমান কিনা চেক করে — চলমান থাকলে সেটাকেই "current"
  // হিসেবে ধরা হয়, রেফারেন্স অ্যাপের মতো।
  Map<String, String>? _currentNafl(int nowMin, dynamic nafl) {
    final windows = <Map<String, String>>[
      {
        'nameBangla': 'ইশরাক',
        'key': 'ishraq',
        'time': nafl.ishraqStart.toString(),
        'endTime': nafl.ishraqEnd.toString(),
      },
      {
        'nameBangla': 'চাশত',
        'key': 'chasht',
        'time': nafl.chashtStart.toString(),
        'endTime': nafl.chashtEnd.toString(),
      },
    ];
    for (final w in windows) {
      final start = _parseTime(w['time']!);
      final end = _parseTime(w['endTime']!);
      if (start == null || end == null) continue;
      if (nowMin >= start && nowMin < end) return w;
    }
    return null;
  }

  // এই মুহূর্তের পর সবচেয়ে কাছের আসন্ন ফরজ নামায খুঁজে বের করে —
  // অল্ট (alt) হেডারে "পরবর্তী ফরজ" হিসেবে দেখানোর জন্য।
  Map<String, String>? _nextFard(int nowMin) {
    Map<String, String>? best;
    int? bestDiff;
    for (final p in _prayersList) {
      final start = _parseTime(p['time']!);
      if (start == null) continue;
      var diff = start - nowMin;
      if (diff < 0) diff += 24 * 60;
      if (bestDiff == null || diff < bestDiff) {
        bestDiff = diff;
        best = p;
      }
    }
    return best;
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.isDarkTheme;

    final cardBorder = dark ? Colors.grey[700]! : const Color(0xFFBEE3C8);
    final labelColor = dark ? Colors.green[300]! : const Color(0xFF2E7D32);
    final timeColor = dark ? Colors.white : const Color(0xFF0F2E2A);
    final cornerTextColor = dark ? Colors.grey[200]! : const Color(0xFF374151);
    final dividerColor = dark ? Colors.white12 : const Color(0xFFE5E7EB);
    final progressBg = dark ? Colors.grey[800]! : const Color(0xFFE5E7EB);
    final mosqueColor = dark ? Colors.white : const Color(0xFF236B34);
    final dashColor = dark ? Colors.amber : const Color(0xFFF59E0B);

    final nafl = calculateNaflTimes(widget.prayerTimes);
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;

    final sunriseMin = _parseTime(widget.prayerTimes.sunrise);
    final maghribMin = _parseTime(widget.prayerTimes.maghrib);

    double arcProgress = 0.5;
    bool showIndicator = false;
    if (sunriseMin != null && maghribMin != null && maghribMin > sunriseMin) {
      arcProgress =
          ((nowMin - sunriseMin) / (maghribMin - sunriseMin)).clamp(0.0, 1.0);
      showIndicator = nowMin >= sunriseMin && nowMin <= maghribMin;
    }

    final current = _currentPrayer(nowMin) ?? _currentNafl(nowMin, nafl);
    final nextFard = _nextFard(nowMin);
    double windowProgress = 0.0;
    String remainingText = '';

    if (current != null) {
      final start = _parseTime(current['time']!)!;
      var end = _parseTime(current['endTime']!)!;
      var nm = nowMin;
      if (end <= start) {
        end += 24 * 60;
        if (nm < start) nm += 24 * 60;
      }
      final total = end - start;
      final elapsed = (nm - start).clamp(0, total);
      windowProgress = total > 0 ? elapsed / total : 0.0;

      final remainMin = (end - nm).clamp(0, total);
      final h = remainMin ~/ 60;
      final m = remainMin % 60;
      remainingText = h > 0
          ? '${bnNum(h)} ঘণ্টা ${bnNum(m)} মিনিট বাকি'
          : '${bnNum(m)} মিনিট বাকি';
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        gradient: dark
            ? null
            : const LinearGradient(
                colors: [Color(0xFFF3FAF5), Color(0xFFE3F2E5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
        color: dark ? Colors.grey[900]!.withValues(alpha: 0.85) : null,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder, width: 1.4),
        boxShadow: dark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFF236B34).withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _showAltLabels = !_showAltLabels),
            child: _showAltLabels && current != null && nextFard != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _labelTime(current['nameBangla']!,
                          bnTime(current['time']!), labelColor, timeColor),
                      _labelTime(nextFard['nameBangla']!,
                          bnTime(nextFard['time']!), labelColor, timeColor),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _labelTime('সাহরি শেষ', bnTime(widget.prayerTimes.fajr),
                          labelColor, timeColor),
                      _labelTime('ইশরাক', bnTime(nafl.ishraqStart), labelColor,
                          timeColor),
                      _labelTime('ইফতার', bnTime(widget.prayerTimes.maghrib),
                          labelColor, timeColor),
                    ],
                  ),
          ),
          SizedBox(
            height: 68,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                  opacity: dark ? 0.10 : 0.14,
                  child: Icon(
                    Icons.mosque,
                    size: 66,
                    color: mosqueColor,
                  ),
                ),
                CustomPaint(
                  size: const Size(double.infinity, 100),
                  painter: _ArcPainter(
                    progress: arcProgress,
                    showIndicator: showIndicator,
                    dashColor: dashColor,
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 4,
                  child: _cornerTime(
                    icon: Icons.nightlight_round,
                    time: bnTime(widget.prayerTimes.fajr),
                    color: cornerTextColor,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 4,
                  child: _cornerTime(
                    icon: Icons.wb_sunny_outlined,
                    time: bnTime(widget.prayerTimes.sunrise),
                    color: cornerTextColor,
                  ),
                ),
              ],
            ),
          ),
          if (current != null) ...[
            Divider(color: dividerColor, height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            dark ? Colors.green[900] : const Color(0xFFE3F2E5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        current['nameBangla']!,
                        style: TextStyle(
                          color: dark
                              ? Colors.green[200]
                              : const Color(0xFF236B34),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${bnTime(current['time']!)} - ${bnTime(current['endTime']!)}',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: windowProgress,
                minHeight: 7,
                backgroundColor: progressBg,
                color: const Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'চলমান',
                  style: TextStyle(
                    color: Colors.green[dark ? 300 : 700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  remainingText,
                  style: TextStyle(
                    color: dark ? Colors.amber : const Color(0xFFB45309),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _labelTime(
    String label,
    String time,
    Color labelColor,
    Color timeColor,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: TextStyle(
            color: timeColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _cornerTime({
    required IconData icon,
    required String time,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.amber[700]),
        const SizedBox(width: 4),
        Text(
          time,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final bool showIndicator;
  final Color dashColor;

  _ArcPainter({
    required this.progress,
    required this.showIndicator,
    required this.dashColor,
  });

  Offset _pointOnArc(Size size, double t) {
    final startX = size.width * 0.1;
    final endX = size.width * 0.9;
    final baseY = size.height * 0.78;
    final topY = size.height * 0.12;

    final x = startX + (endX - startX) * t;
    final arcShape = 1 - (4 * (t - 0.5) * (t - 0.5));
    final y = baseY - (baseY - topY) * arcShape;

    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = dashColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke;

    const dashCount = 40;
    for (int i = 0; i < dashCount; i++) {
      if (i.isOdd) continue;
      final p1 = _pointOnArc(size, i / dashCount);
      final p2 = _pointOnArc(size, (i + 0.6) / dashCount);
      canvas.drawLine(p1, p2, dashPaint);
    }

    if (showIndicator) {
      final pos = _pointOnArc(size, progress);

      canvas.drawCircle(
        pos,
        15,
        Paint()
          ..color = Colors.amber.withValues(alpha: 0.22)
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        pos,
        7.5,
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
          ).createShader(Rect.fromCircle(center: pos, radius: 7.5)),
      );
      canvas.drawCircle(
        pos,
        7.5,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 1.6
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.showIndicator != showIndicator ||
        oldDelegate.dashColor != dashColor;
  }
}
