import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nafl_times.dart' show bnNum;

const List<String> _dhikrList = [
  'সুবহানাল্লাহ',
  'আলহামদুলিল্লাহ',
  'আল্লাহু আকবার',
  'লা ইলাহা ইল্লাল্লাহ',
  'আস্তাগফিরুল্লাহ',
  'সুবহানাল্লাহি ওয়া বিহামদিহি',
  'লা হাওলা ওয়ালা কুওয়াতা ইল্লা বিল্লাহ',
];

/// তাসবিহ কাউন্টার — main.dart-এর `case 'tasbih':`-এর জন্য।
class TasbihSection extends StatefulWidget {
  final bool isDarkTheme;

  const TasbihSection({
    super.key,
    this.isDarkTheme = false,
  });

  @override
  State<TasbihSection> createState() => _TasbihSectionState();
}

class _TasbihSectionState extends State<TasbihSection> {
  int totalCount = 0; // আজীবন সর্বমোট — কখনো থামে/ক্যাপ হয় না
  int target = 33;
  int dhikrIndex = 1;
  bool soundEnabled = true;

  int get countInRound => target > 0 ? totalCount % target : totalCount;
  int get roundsCompleted => target > 0 ? totalCount ~/ target : 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      totalCount = prefs.getInt('nur_tasbih_total') ?? 0;
      target = prefs.getInt('nur_tasbih_target') ?? 33;
      dhikrIndex = prefs.getInt('nur_tasbih_dhikr_index') ?? 1;
      soundEnabled = prefs.getBool('nur_tasbih_sound') ?? true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('nur_tasbih_total', totalCount);
    await prefs.setInt('nur_tasbih_target', target);
    await prefs.setInt('nur_tasbih_dhikr_index', dhikrIndex);
    await prefs.setBool('nur_tasbih_sound', soundEnabled);
  }

  void _handleTap() {
    if (soundEnabled) HapticFeedback.lightImpact();
    setState(() => totalCount += 1);
    _save();
  }

  void _handleReset() {
    HapticFeedback.mediumImpact();
    setState(() => totalCount = 0);
    _save();
  }

  void _handlePrevDhikr() {
    setState(() {
      dhikrIndex = (dhikrIndex - 1 + _dhikrList.length) % _dhikrList.length;
    });
    _save();
  }

  void _handleNextDhikr() {
    setState(() {
      dhikrIndex = (dhikrIndex + 1) % _dhikrList.length;
    });
    _save();
  }

  void _toggleSound() {
    setState(() => soundEnabled = !soundEnabled);
    _save();
  }

  void _openTargetSheet() {
    final dark = widget.isDarkTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: dark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'প্রতি রাউন্ডে লক্ষ্য',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: dark ? Colors.white : const Color(0xFF0F2E2A),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [3, 33, 99, 100, 1000].map((t) {
                  final isActive = target == t;
                  return InkWell(
                    onTap: () {
                      setState(() => target = t);
                      _save();
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.green[600]
                            : (dark
                                ? Colors.grey[850]
                                : const Color(0xFFF0F2F1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        bnNum(t),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isActive
                              ? Colors.white
                              : (dark
                                  ? Colors.grey[300]
                                  : const Color(0xFF3F4B47)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.isDarkTheme;
    final fraction = target > 0 ? countInRound / target : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDhikrSelector(dark),
        const SizedBox(height: 18),
        _buildIconRow(dark),
        const SizedBox(height: 36),
        Center(child: _buildCounterRing(dark, fraction)),
        const SizedBox(height: 20),
        _buildFooterRow(dark),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDhikrSelector(bool dark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: dark ? Colors.grey[850] : const Color(0xFFDCE3EA),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _handlePrevDhikr,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.chevron_left,
                color: dark ? Colors.grey[300] : const Color(0xFF3F4B47),
              ),
            ),
          ),
          Expanded(
            child: Text(
              _dhikrList[dhikrIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : const Color(0xFF16371E),
              ),
            ),
          ),
          InkWell(
            onTap: _handleNextDhikr,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Icon(
                Icons.chevron_right,
                color: dark ? Colors.grey[300] : const Color(0xFF3F4B47),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconRow(bool dark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleIconButton(
          icon: Icons.settings,
          color: Colors.amber[700]!,
          dark: dark,
          onTap: _openTargetSheet,
        ),
        _circleIconButton(
          icon: Icons.refresh,
          color: Colors.green[600]!,
          dark: dark,
          onTap: _handleReset,
        ),
        _circleIconButton(
          icon: soundEnabled ? Icons.volume_up : Icons.volume_off,
          color: dark ? Colors.grey[300]! : const Color(0xFF3F4B47),
          dark: dark,
          onTap: _toggleSound,
        ),
      ],
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required Color color,
    required bool dark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: dark ? Colors.grey[850] : const Color(0xFFE3E7E4),
          border: Border.all(
            color: dark ? Colors.grey[700]! : const Color(0xFFCBD3CE),
          ),
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }

  Widget _buildCounterRing(bool dark, double fraction) {
    return GestureDetector(
      onTap: _handleTap,
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(280, 280),
              painter: _RingDotPainter(
                fraction: fraction,
                ringColor: dark ? Colors.grey[700]! : const Color(0xFFB9C4C1),
                dotColor: const Color(0xFF22D3EE),
              ),
            ),
            Text(
              bnNum(countInRound),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: dark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            // রাউন্ড কাউন্টার — ডান-নিচে ছোট বৃত্ত
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dark ? Colors.grey[850] : const Color(0xFFEFF3F1),
                  border: Border.all(
                    color: dark ? Colors.grey[700]! : const Color(0xFFB9C4C1),
                  ),
                ),
                child: Text(
                  bnNum(roundsCompleted),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: dark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterRow(bool dark) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: dark ? Colors.grey[700]! : const Color(0xFFB9C4C1),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'সর্বমোট: ${bnNum(totalCount)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white : const Color(0xFF16371E),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// বৃত্তের রিং + প্রগ্রেস ডট — countInRound/target অনুযায়ী ডটটা
// উপর (১২টার কাঁটার অবস্থান) থেকে শুরু করে ঘড়ির কাঁটার দিকে ঘোরে।
// লক্ষ্যে পৌঁছালে (fraction == 0, নতুন রাউন্ড শুরু) ডট আবার উপরে
// ফিরে যায় — কাউন্টার থামে না, এখানেই "চালিয়ে যাওয়ার" ভিজ্যুয়াল।
// ==========================================================
class _RingDotPainter extends CustomPainter {
  final double fraction;
  final Color ringColor;
  final Color dotColor;

  _RingDotPainter({
    required this.fraction,
    required this.ringColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final ringPaint = Paint()
      ..color = ringColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, ringPaint);

    final angle = -math.pi / 2 + (2 * math.pi * fraction);
    final dotCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawCircle(
      dotCenter,
      16,
      Paint()..color = dotColor.withOpacity(0.25),
    );
    canvas.drawCircle(
      dotCenter,
      9,
      Paint()..color = dotColor,
    );
  }

  @override
  bool shouldRepaint(covariant _RingDotPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.ringColor != ringColor ||
        oldDelegate.dotColor != dotColor;
  }
}
