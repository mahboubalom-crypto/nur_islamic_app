import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class AzanAlarmScreen extends StatefulWidget {
  final String prayerNameBangla; // যেমন: মাগরিব
  final String currentTimeStr; // যেমন: ২০:৩৭
  final String gregorianDateStr; // যেমন: আজ ১২ আগস্ট, ২০২৬
  final String hijriDateStr; // যেমন: ৩০ সফর, ১৪৪৮ হিজরি
  final String cityName; // যেমন: Milano
  final String waqtTimeStr; // যেমন: 8:37 PM
  final String adjustmentStr; // যেমন: ০ মিনিট
  final String alarmTimeStr; // যেমন: 8:37 PM
  final String hadithQuote; // যেমন: "নামায হলো জান্নাতের চাবি।"
  final String hadithSource; // যেমন: সুনানে তিরমিজি: ৪
  final String nextPrayerNameBangla; // যেমন: ইশা
  final String nextPrayerTimeStr; // যেমন: 10:26 PM
  final VoidCallback onDismiss;

  const AzanAlarmScreen({
    super.key,
    required this.prayerNameBangla,
    required this.currentTimeStr,
    required this.gregorianDateStr,
    required this.hijriDateStr,
    required this.cityName,
    required this.waqtTimeStr,
    required this.adjustmentStr,
    required this.alarmTimeStr,
    required this.hadithQuote,
    required this.hadithSource,
    required this.nextPrayerNameBangla,
    required this.nextPrayerTimeStr,
    required this.onDismiss,
  });

  @override
  State<AzanAlarmScreen> createState() => _AzanAlarmScreenState();
}

class _AzanAlarmScreenState extends State<AzanAlarmScreen>
    with WidgetsBindingObserver {
  double _dragX = 0;
  static const double _trackWidth = 320;
  static const double _knobSize = 56;
  static const Duration _autoDismissAfter = Duration(minutes: 3);

  Timer? _autoDismissTimer;
  bool _dismissed = false;
  late final DateTime _deadline;

  @override
  void initState() {
    super.initState();
    // এই মুহূর্তের প্রকৃত ঘড়ির সময় থেকে ৩ মিনিট পরের একটা "deadline"
    // হিসাব করে রাখা হচ্ছে — শুধু Timer-এর উপর নির্ভর না করে, কারণ
    // স্ক্রিন লক হয়ে গেলে Timer থেমে যেতে পারে, কিন্তু আসল ঘড়ি থামে না।
    _deadline = DateTime.now().add(_autoDismissAfter);

    WidgetsBinding.instance.addObserver(this);

    // ফোরগ্রাউন্ডে থাকা অবস্থায় স্বাভাবিক Timer দিয়েই চেষ্টা করবে।
    // একবারের Timer-এর বদলে প্রতি ১০ সেকেন্ডে চেক করা হচ্ছে — এতে
    // কোনো একবারের misfire হলেও পরের চেকে ধরা পড়বে।
    _autoDismissTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (DateTime.now().isAfter(_deadline)) {
        timer.cancel();
        _dismissOnce();
      }
    });
    // পপ-আপ চলা অবস্থায় স্ক্রিন লক/অফ হয়ে গেলে টাইমারও থেমে যেতে পারে —
    // তাই স্ক্রিন জাগিয়ে রাখার চেষ্টা করা হচ্ছে।
    WakelockPlus.enable();
  }

  // ==========================================================
  // অ্যাপ ব্যাকগ্রাউন্ডে গিয়ে (স্ক্রিন লক হয়ে) আবার ফোরগ্রাউন্ডে
  // ফিরলে (resumed) — Timer থেমে থাকলেও, এখানে আসল ঘড়ির সময় (deadline)
  // চেক করে দেরি হয়ে থাকলে সাথে সাথে বন্ধ করে দেওয়া হয়।
  // ==========================================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (DateTime.now().isAfter(_deadline)) {
        _dismissOnce();
      }
    }
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  void _dismissOnce() {
    if (_dismissed) return;
    _dismissed = true;
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    // build() যতবারই কল হয় (স্ক্রিন রিড্র/রিজিউম হলেও) ততবারই আসল
    // ঘড়ির সময় চেক করা হচ্ছে — শুধু lifecycle event বা Timer-এর
    // উপর নির্ভর না করে, যাতে কোনো কারণে সেগুলো miss হলেও এটা catch করে।
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_dismissed && DateTime.now().isAfter(_deadline)) {
        _dismissOnce();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF0B1F1C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ব্যাকগ্রাউন্ড — মসজিদের সিলুয়েট + গ্র্যাডিয়েন্ট
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0B1F1C),
                  Color(0xFF16342E),
                  Color(0xFF0B1F1C)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.18,
              child: Icon(Icons.mosque,
                  size: 320, color: Colors.greenAccent.shade100),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _buildLogo(),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.nightlight_round,
                          color: Colors.amber.shade200, size: 20),
                      const SizedBox(width: 8),
                      Container(width: 30, height: 1, color: Colors.white24),
                      const SizedBox(width: 8),
                      const Icon(Icons.diamond,
                          color: Colors.greenAccent, size: 10),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.prayerNameBangla}ের অ্যালার্ম বাজছে',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.diamond,
                          color: Colors.greenAccent, size: 10),
                      const SizedBox(width: 8),
                      Container(width: 30, height: 1, color: Colors.white24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.currentTimeStr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 78,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _buildDateCard(),
                  const SizedBox(height: 14),
                  _buildPrayerInfoCard(),
                  const SizedBox(height: 20),
                  _buildNextPrayerSection(),
                  const SizedBox(height: 22),
                  _buildSlideToDismiss(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.greenAccent.shade400, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.mosque, color: Colors.greenAccent, size: 44),
      ),
    );
  }

  Widget _buildDateCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.gregorianDateStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.hijriDateStr,
                style: const TextStyle(color: Colors.white60, fontSize: 12.5),
              ),
            ],
          ),
          const Icon(Icons.calendar_month, color: Colors.white54, size: 26),
        ],
      ),
    );
  }

  Widget _buildPrayerInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.prayerNameBangla,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 14, color: Colors.greenAccent),
                    const SizedBox(width: 4),
                    Text(widget.cityName,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '"${widget.hadithQuote}"',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.hadithSource,
            style: const TextStyle(color: Colors.white38, fontSize: 11.5),
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.access_time, 'ওয়াক্তের সময়', widget.waqtTimeStr),
          const SizedBox(height: 10),
          _infoRow(Icons.tune, 'অ্যাডজাস্টমেন্ট', widget.adjustmentStr),
          const SizedBox(height: 10),
          _infoRow(Icons.notifications_active, 'অ্যালার্মের সময়',
              widget.alarmTimeStr),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.greenAccent.shade100),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 18, color: Colors.greenAccent),
            const SizedBox(width: 8),
            const Text(
              'পরবর্তী নামায',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3B2E7A),
                ),
                child: const Icon(Icons.nightlight_round,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.nextPrayerNameBangla,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                widget.nextPrayerTimeStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: Colors.white54),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlideToDismiss() {
    return Container(
      width: _trackWidth,
      height: 64,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          const Center(
            child: Text(
              'স্লাইড করে অ্যালার্ম বন্ধ করুন',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: _dragX,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragX += details.delta.dx;
                  _dragX = _dragX.clamp(0, _trackWidth - _knobSize - 8);
                });
              },
              onHorizontalDragEnd: (details) {
                if (_dragX > (_trackWidth - _knobSize - 8) * 0.75) {
                  _dismissOnce();
                } else {
                  setState(() => _dragX = 0);
                }
              },
              child: Container(
                width: _knobSize,
                height: _knobSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent,
                ),
                child: const Icon(Icons.arrow_forward,
                    color: Color(0xFF0B1F1C), size: 26),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
