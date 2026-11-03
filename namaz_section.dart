import 'package:flutter/material.dart';

/// একটি namaz-এর ধাপ (নিয়ত থেকে সালাম) — "সম্পূর্ণ নামায" page-এ ব্যবহৃত হয়
class NamazStepData {
  final String title;
  final String content;
  final IconData icon;
  final MaterialColor color;

  const NamazStepData({
    required this.title,
    required this.content,
    required this.icon,
    required this.color,
  });
}

/// নিয়ত থেকে সালাম পর্যন্ত ধাপসমূহ (আগের পৃথক card গুলোর content এখানে সংরক্ষিত)
final List<NamazStepData> namazSteps = [
  const NamazStepData(
    title: 'নামাযের নিয়ত',
    icon: Icons.menu_book,
    color: Colors.amber,
    content: '''
নামাযের নিয়ত মূলত অন্তরের ইচ্ছা।

কোন নামায আদায় করছেন তা অন্তরে নির্ধারণ করে তাকবিরে তাহরিমা দিয়ে নামায শুরু করবেন।
''',
  ),
  const NamazStepData(
    title: 'তাকবিরে তাহরিমা',
    icon: Icons.pan_tool_outlined,
    color: Colors.blue,
    content: '''
নিয়ত করে কিবলামুখী হয়ে দাঁড়াবেন।

اللَّهُ أَكْبَرُ

অর্থ:
আল্লাহ সর্বশ্রেষ্ঠ।

এরপর হাত বাঁধবেন এবং কিয়াম শুরু করবেন।
''',
  ),
  const NamazStepData(
    title: 'কিয়াম',
    icon: Icons.accessibility_new,
    color: Colors.teal,
    content: '''
নামাযে দাঁড়িয়ে কিরাআত পড়বেন।

সূরা ফাতিহা পড়ার পর একটি সূরা বা কিছু আয়াত পড়বেন।

এরপর রুকুতে যাবেন।
''',
  ),
  const NamazStepData(
    title: 'রুকু',
    icon: Icons.keyboard_arrow_down,
    color: Colors.orange,
    content: '''
রুকুতে পড়বেন:

سُبْحَانَ رَبِّيَ الْعَظِيمِ

অর্থ:
আমার মহান প্রতিপালক পবিত্র।

রুকু থেকে ওঠার সময় বলবেন:

سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ

তারপর:

رَبَّنَا لَكَ الْحَمْدُ
''',
  ),
  const NamazStepData(
    title: 'সিজদা',
    icon: Icons.self_improvement,
    color: Colors.purple,
    content: '''
সিজদায় পড়বেন:

سُبْحَانَ رَبِّيَ الْأَعْلَى

অর্থ:
আমার সর্বোচ্চ প্রতিপালক পবিত্র।

দুই সিজদার মাঝখানে বসে আবার দ্বিতীয় সিজদা করবেন।
''',
  ),
  const NamazStepData(
    title: 'তাশাহহুদ',
    icon: Icons.event_seat,
    color: Colors.indigo,
    content: '''
শেষ বৈঠকে তাশাহহুদ পড়বেন:

التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ

এরপর দরুদ শরিফ এবং মাসনূন দোয়া পড়বেন।
''',
  ),
  const NamazStepData(
    title: 'দরুদ শরিফ',
    icon: Icons.favorite_border,
    color: Colors.pink,
    content: '''
তাশাহহুদের পর দরুদে ইবরাহিম পড়বেন।

اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ

এরপর মাসনূন দোয়া পড়বেন।
''',
  ),
  const NamazStepData(
    title: 'সালাম',
    icon: Icons.waving_hand,
    color: Colors.green,
    content: '''
ডান দিকে মুখ ফিরিয়ে বলবেন:

السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ

এরপর বাম দিকে মুখ ফিরিয়ে একইভাবে বলবেন:

السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ

এভাবেই নামায শেষ হবে।
''',
  ),
];

class NamazSection extends StatelessWidget {
  const NamazSection({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = [
      {
        'title': 'নামাযের ওয়াক্ত',
        'subtitle': 'পাঁচ ওয়াক্ত নামাযের সময় ও রাকাত',
        'icon': Icons.access_time,
        'color': Colors.green,
        'content': '''
ফজর: ২ রাকাত ফরজ
যোহর: ৪ রাকাত ফরজ
আসর: ৪ রাকাত ফরজ
মাগরিব: ৩ রাকাত ফরজ
এশা: ৪ রাকাত ফরজ
''',
      },
      {
        'title': 'সম্পূর্ণ নামায (ধাপে ধাপে)',
        'subtitle': 'নিয়ত থেকে সালাম পর্যন্ত ধাপে ধাপে শিখুন',
        'icon': Icons.self_improvement,
        'color': Colors.teal,
        'isStepByStep': true,
      },
      {
        'title': 'নামাযে ভুল হলে',
        'subtitle': 'সাহু সিজদার সংক্ষিপ্ত ধারণা',
        'icon': Icons.help_outline,
        'color': Colors.red,
        'content': '''
নামাযে ভুল হলে সব ভুলের একই বিধান নয়।

কোন ভুলে সাহু সিজদা করতে হয় এবং কোন ভুলে নামায পুনরায় পড়তে হয় তা নির্ভরযোগ্য আলেমের কাছ থেকে জেনে নেওয়া উচিত।

মাযহাবভেদে কিছু মাসআলায় পার্থক্য রয়েছে।
''',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        ...topics.map(
          (topic) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTopicCard(context, topic),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF064E3B),
            Color(0xFF0F2E2A),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.mosque,
                color: Colors.amber,
                size: 25,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'নামায শিক্ষা',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'নামাযের গুরুত্বপূর্ণ বিষয়গুলো ধাপে ধাপে শিখুন',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    Map<String, dynamic> topic,
  ) {
    final color = topic['color'] as MaterialColor;
    final isStepByStep = topic['isStepByStep'] == true;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        if (isStepByStep) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const NamazStepByStepPage(),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazTopicPage(
                title: topic['title'] as String,
                subtitle: topic['subtitle'] as String,
                icon: topic['icon'] as IconData,
                color: color,
                content: topic['content'] as String,
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey[700]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color[900],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color[700]!,
                ),
              ),
              child: Icon(
                topic['icon'] as IconData,
                color: color[300],
                size: 25,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic['subtitle'] as String,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[500],
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

/// আগের 8টা আলাদা topic card-এর জায়গায় — নিয়ত থেকে সালাম পর্যন্ত
/// ক্রমানুসারে next/previous দিয়ে দেখার পেজ। existing dark theme অনুসরণ করে।
class NamazStepByStepPage extends StatefulWidget {
  const NamazStepByStepPage({super.key});

  @override
  State<NamazStepByStepPage> createState() => _NamazStepByStepPageState();
}

class _NamazStepByStepPageState extends State<NamazStepByStepPage> {
  int _currentIndex = 0;

  void _goNext() {
    if (_currentIndex < namazSteps.length - 1) {
      setState(() => _currentIndex++);
    }
  }

  void _goPrevious() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = namazSteps[_currentIndex];
    final color = step.color;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF042F2E),
        foregroundColor: Colors.white,
        title: const Text(
          'সম্পূর্ণ নামায (ধাপে ধাপে)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // অগ্রগতি নির্দেশক
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / namazSteps.length,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: Colors.grey[800],
                    color: color[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ধাপ ${_currentIndex + 1} / ${namazSteps.length}',
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: color[900],
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: color[700]!),
                    ),
                    child: Column(
                      children: [
                        Icon(step.icon, color: color[200], size: 42),
                        const SizedBox(height: 10),
                        Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[700]!),
                    ),
                    child: Text(
                      step.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // নেভিগেশন বাটন
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _currentIndex == 0 ? null : _goPrevious,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('পূর্বের ধাপ'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: color[700],
                      ),
                      onPressed: _currentIndex == namazSteps.length - 1
                          ? null
                          : _goNext,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('পরের ধাপ'),
                    ),
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

class NamazTopicPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final MaterialColor color;
  final String content;

  const NamazTopicPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF042F2E),
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color[900],
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: color[700]!,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: color[200],
                  size: 42,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color[100],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey[700]!,
              ),
            ),
            child: Text(
              content,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 2,
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
