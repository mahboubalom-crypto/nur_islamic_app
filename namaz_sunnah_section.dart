import 'package:flutter/material.dart';

class NamazSunnahCategory {
  final String title;
  final IconData icon;
  final List<NamazSunnahPoint> points;

  const NamazSunnahCategory({
    required this.title,
    required this.icon,
    required this.points,
  });
}

class NamazSunnahPoint {
  final String text;
  final String reference;
  final String? detail;

  const NamazSunnahPoint({
    required this.text,
    required this.reference,
    this.detail,
  });
}

// ==========================================================
// ⚠️ প্রতিটা পয়েন্টের বিবরণ সাধারণভাবে পরিচিত হানাফি ফিকহ অনুযায়ী
// নিজের ভাষায় লেখা হয়েছে। রেফারেন্সে শুধু হাদিস গ্রন্থের নাম দেওয়া
// আছে, নির্দিষ্ট হাদিস নম্বর নয় — কারণ ভুল নম্বর বসানো অনুচিত হবে।
// এই নম্বরগুলো আসল বই/অ্যাপ থেকে যাচাই করে বসাতে চাইলে জানিও।
// ==========================================================
const List<NamazSunnahCategory> namazSunnahCategories = [
  NamazSunnahCategory(
    title: 'দাঁড়ানো অবস্থায়',
    icon: Icons.accessibility_new,
    points: [
      NamazSunnahPoint(
        text: 'দুই পায়ের আঙুল কিবলামুখী রেখে দাঁড়ানো, দুই পায়ের মাঝে '
            'সামান্য ফাঁকা (প্রায় চার আঙুল পরিমাণ) রাখা।',
        reference: 'সুনানে নাসাঈ',
      ),
      NamazSunnahPoint(
        text: 'তাকবীরে তাহরিমার সময় চেহারা কিবলার দিকে রেখে, দৃষ্টি সিজদার '
            'জায়গায় রাখা এবং মাথা না ঝুঁকানো।',
        reference: 'জামে তিরমিজি, সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'পুরুষদের জন্য তাকবীরে তাহরিমার সময় উভয় হাত কান পর্যন্ত '
            'উঠানো — বৃদ্ধাঙ্গুলি কানের লতি পর্যন্ত স্পর্শ করানো।',
        reference: 'সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'হাত উঠানোর সময় হাতের তালু কিবলামুখী রাখা।',
        reference: 'মু\'জামুল আওসাত, তাবারানি',
      ),
      NamazSunnahPoint(
        text: 'হাত উঠানোর সময় আঙুলগুলো স্বাভাবিক রাখা — না একদম মিলিয়ে, '
            'না বেশি ছড়িয়ে।',
        reference: 'মুসতাদরাকে হাকিম',
      ),
      NamazSunnahPoint(
        text: 'মুক্তাদির তাকবীরে তাহরিমা ইমামের তাকবীরের পরপরই বলা — '
            'ইমামের আগে শেষ হলে ইকতিদা সহীহ হবে না।',
        reference: 'সহীহ বুখারী, সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'হাত বাঁধার সময় ডান হাতের তালু বাম হাতের পিঠের উপর রাখা।',
        reference: 'মুসান্নাফে ইবনে আবী শাইবা',
      ),
      NamazSunnahPoint(
        text: 'ডান হাতের বৃদ্ধাঙ্গুলি ও কনিষ্ঠাঙ্গুলি দিয়ে বৃত্তের মতো '
            'বানিয়ে বাম হাতের কব্জি ধরা।',
        reference: 'তাহতাবী, জামে তিরমিজি',
      ),
      NamazSunnahPoint(
        text: 'মধ্যের তিন আঙুল সহজভাবে বাহুর উপর রাখা।',
        reference: 'ফাতহুল কাদির, তাহতাবী',
      ),
      NamazSunnahPoint(
        text: 'পুরুষদের জন্য নাভির নিচে হাত বাঁধা।',
        reference: 'মুসান্নাফে ইবনে আবী শাইবা',
      ),
      NamazSunnahPoint(
        text: 'হাত বাঁধার পর সানা (সুবহানাকাল্লাহুম্মা...) শেষ পর্যন্ত পড়া।',
        reference: 'সুনানে আবু দাউদ, জামে তিরমিজি',
      ),
    ],
  ),
  NamazSunnahCategory(
    title: 'কেরাত',
    icon: Icons.menu_book,
    points: [
      NamazSunnahPoint(
        text: 'সানার পর তাআওউজ (আউযু বিল্লাহি...) আস্তে পড়া।',
        reference: 'সুনানে আবু দাউদ',
      ),
      NamazSunnahPoint(
        text: 'তাআওউজের পর তাসমিয়া (বিসমিল্লাহির রাহমানির রাহীম) আস্তে পড়া।',
        reference: 'জামে তিরমিজি',
      ),
      NamazSunnahPoint(
        text: 'ইমাম ফজর ও মাগরিব-এশার প্রথম দুই রাকাতে সূরা ফাতিহা ও অন্য '
            'সূরা জোরে পড়বেন; যোহর-আসরে আস্তে পড়বেন।',
        reference: 'সহীহ বুখারী, সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'সূরা ফাতিহা শেষে "আমীন" বলা — ইমাম জোরে, মুক্তাদি নিজের '
            'অবস্থা অনুযায়ী।',
        reference: 'সুনানে আবু দাউদ',
      ),
      NamazSunnahPoint(
        text: 'প্রতি রাকাতে সূরা ফাতিহার পর অতিরিক্ত একটা সূরা বা কয়েকটা '
            'আয়াত মিলিয়ে পড়া (তৃতীয়-চতুর্থ রাকাত ছাড়া ফরজ নামাজে)।',
        reference: 'সহীহ বুখারী',
      ),
    ],
  ),
  NamazSunnahCategory(
    title: 'রুকুরত অবস্থায়',
    icon: Icons.arrow_downward,
    points: [
      NamazSunnahPoint(
        text: 'রুকুতে যাওয়ার সময় তাকবীর বলা।',
        reference: 'সহীহ বুখারী',
      ),
      NamazSunnahPoint(
        text: 'রুকুতে দুই হাত দিয়ে হাঁটু শক্তভাবে ধরা, আঙুলগুলো ফাঁকা '
            'রাখা।',
        reference: 'সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'রুকুতে পিঠ সোজা রাখা, মাথা পিঠের সমান্তরালে রাখা — না বেশি '
            'উঁচু, না বেশি নিচু।',
        reference: 'সুনানে আবু দাউদ',
      ),
      NamazSunnahPoint(
        text: 'রুকুতে অন্তত তিনবার "সুবহানা রাব্বিয়াল আযীম" পড়া।',
        reference: 'সুনানে আবু দাউদ, জামে তিরমিজি',
      ),
      NamazSunnahPoint(
        text: 'রুকু থেকে ওঠার সময় ইমাম "সামিআল্লাহু লিমান হামিদাহ" এবং '
            'মুক্তাদি "রাব্বানা লাকাল হামদ" বলা।',
        reference: 'সহীহ বুখারী',
      ),
    ],
  ),
  NamazSunnahCategory(
    title: 'সিজদারত অবস্থায়',
    icon: Icons.self_improvement,
    points: [
      NamazSunnahPoint(
        text: 'সিজদায় যাওয়ার সময় প্রথমে হাঁটু, তারপর হাত, তারপর কপাল ও '
            'নাক মাটিতে রাখা।',
        reference: 'সুনানে আবু দাউদ, জামে তিরমিজি',
      ),
      NamazSunnahPoint(
        text: 'সিজদায় সাত অঙ্গের (কপাল-নাক, দুই হাত, দুই হাঁটু, দুই পায়ের '
            'আঙুল) উপর ভর দেওয়া।',
        reference: 'সহীহ বুখারী, সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'সিজদায় দুই বাহু পেট থেকে ও কনুই মাটি থেকে আলাদা রাখা '
            '(পুরুষদের জন্য)।',
        reference: 'সহীহ বুখারী',
      ),
      NamazSunnahPoint(
        text: 'সিজদায় অন্তত তিনবার "সুবহানা রাব্বিয়াল আ\'লা" পড়া।',
        reference: 'সুনানে আবু দাউদ, জামে তিরমিজি',
      ),
      NamazSunnahPoint(
        text: 'দুই সিজদার মাঝে সংক্ষিপ্ত বসা (জালসা) অবস্থায় স্বাভাবিকভাবে '
            'বসে দুই সিজদার মাঝের দোয়া বা নীরবতা রাখা।',
        reference: 'সহীহ বুখারী',
      ),
    ],
  ),
  NamazSunnahCategory(
    title: 'নামাজে বসা অবস্থায়',
    icon: Icons.airline_seat_legroom_normal,
    points: [
      NamazSunnahPoint(
        text: 'তাশাহহুদের বৈঠকে বাম পা বিছিয়ে তার উপর বসা এবং ডান পা খাড়া '
            'রাখা (পুরুষদের জন্য)।',
        reference: 'সহীহ বুখারী',
      ),
      NamazSunnahPoint(
        text: 'দুই হাত উরুর উপর রাখা, আঙুলগুলো স্বাভাবিকভাবে বিছিয়ে রাখা।',
        reference: 'সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'তাশাহহুদে "আশহাদু আল্লা ইলাহা ইল্লাল্লাহ" বলার সময় ডান '
            'হাতের শাহাদাত আঙুল দিয়ে ইশারা করা।',
        reference: 'সহীহ মুসলিম',
      ),
      NamazSunnahPoint(
        text: 'শেষ বৈঠকে তাশাহহুদের পর দরুদ শরীফ পড়া।',
        reference: 'সহীহ বুখারী',
      ),
      NamazSunnahPoint(
        text: 'সালামের আগে মাসনুন দোয়া পড়া, তারপর ডানে ও বামে সালাম '
            'ফিরানো।',
        reference: 'সুনানে আবু দাউদ, জামে তিরমিজি',
      ),
    ],
  ),
];

class NamazSunnahSection extends StatelessWidget {
  final void Function(String tab)? setActiveTab;

  const NamazSunnahSection({super.key, this.setActiveTab});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text(
                'নামাজ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: namazSunnahCategories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cat = namazSunnahCategories[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => NamazSunnahDetailPage(category: cat),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF236B34)
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(cat.icon,
                                color: const Color(0xFF236B34), size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              cat.title,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_left,
                              color: Color(0xFF9CA3AF), size: 22),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Color(0xFF1F2937)),
            onPressed: () {
              Navigator.of(context).popUntil((r) => r.isFirst);
              if (setActiveTab != null) setActiveTab!('bibidh');
            },
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class NamazSunnahDetailPage extends StatelessWidget {
  final NamazSunnahCategory category;

  const NamazSunnahDetailPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: category.points.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final point = category.points[index];
                  return _SunnahPointCard(
                    index: index,
                    point: point,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.home_outlined,
                        color: Color(0xFF1F2937)),
                    onPressed: () {
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                  ),
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SunnahPointCard extends StatefulWidget {
  final int index;
  final NamazSunnahPoint point;

  const _SunnahPointCard({required this.index, required this.point});

  @override
  State<_SunnahPointCard> createState() => _SunnahPointCardState();
}

class _SunnahPointCardState extends State<_SunnahPointCard> {
  bool _expanded = false;

  String _toBanglaNumber(int number) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var s = number.toString();
    for (var i = 0; i < en.length; i++) {
      s = s.replaceAll(en[i], bn[i]);
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final point = widget.point;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '(${_toBanglaNumber(widget.index + 1)}) ${point.text}',
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '- ${point.reference}',
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF6B7280),
            ),
          ),
          if (point.detail != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'বিস্তারিত',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF236B34),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 18,
                    color: const Color(0xFF236B34),
                  ),
                ],
              ),
            ),
            if (_expanded) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  point.detail!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.8,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
