import 'package:flutter/material.dart';
import 'fasting_dua_section.dart'; // ← নতুন import

class FastingTopicData {
  final String title;
  final String subtitle;
  final String emoji;
  final MaterialColor color;
  final String content;

  const FastingTopicData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.content,
  });
}

final List<FastingTopicData> fastingTopics = [
  const FastingTopicData(
    title: 'রোজার ফরজিয়ত ও গুরুত্ব',
    subtitle: 'ইসলামের পাঁচ স্তম্ভের একটি',
    emoji: '🌙',
    color: Colors.teal,
    content: '''
রমজান মাসের রোজা প্রত্যেক প্রাপ্তবয়স্ক, সুস্থ, বিবেকবান মুসলিম নর-নারীর উপর ফরজ।

আল্লাহ তাআলা বলেন, "হে ঈমানদারগণ! তোমাদের উপর রোজা ফরজ করা হয়েছে, যেমন ফরজ করা হয়েছিল তোমাদের পূর্ববর্তীদের উপর, যাতে তোমরা মুত্তাকী হতে পার।" (সূরা বাকারা, আয়াত ১৮৩)

অসুস্থ, মুসাফির, গর্ভবতী/স্তন্যদানকারী নারী এবং বৃদ্ধ-অক্ষম ব্যক্তির জন্য ইসলামে বিশেষ ছাড় ও বিধান রয়েছে — এ বিষয়ে নির্ভরযোগ্য আলেমের পরামর্শ নেওয়া উচিত।
''',
  ),
  const FastingTopicData(
    title: 'রোজার নিয়ত',
    subtitle: 'সেহরির সময় অন্তরে সংকল্প',
    emoji: '📖',
    color: Colors.amber,
    content: '''
রোজার নিয়ত মূলত অন্তরের ইচ্ছা — মুখে উচ্চারণ করা জরুরি নয়, তবে অনেকে সহজতার জন্য মুখেও বলে থাকেন।

সুবহে সাদিকের (ফজরের) পূর্বে অন্তরে এই সংকল্প করা যথেষ্ট যে, "আমি আগামীকাল আল্লাহর সন্তুষ্টির জন্য রোজা রাখছি।"

নফল রোজার নিয়ত দিনের বেলাতেও (দুপুরের পূর্ব পর্যন্ত, কিছু না খাওয়া থাকলে) করা যায় বলে অনেক আলেম মত দিয়েছেন।
''',
  ),
  const FastingTopicData(
    title: 'সেহরি খাওয়ার ফজিলত',
    subtitle: 'বরকতময় একটি সুন্নাত',
    emoji: '🌅',
    color: Colors.orange,
    content: '''
রাসূলুল্লাহ (সাল্লাল্লাহু আলাইহি ওয়াসাল্লাম) বলেছেন, "তোমরা সেহরি খাও, কেননা সেহরিতে বরকত রয়েছে।" (সহীহ বুখারী, সহীহ মুসলিম)

সেহরি দেরি করে (ফজরের কাছাকাছি সময়ে) খাওয়া সুন্নাত।

সেহরি না পেলেও রোজা রাখতে কোনো বাধা নেই — সেহরি ফরজ নয়, তবে এটি রাখা উত্তম ও বরকতের কারণ।
''',
  ),
  const FastingTopicData(
    title: 'ইফতারের দোয়া ও নিয়ম',
    subtitle: 'সূর্যাস্তের সাথে সাথে ইফতার',
    emoji: '🌇',
    color: Colors.purple,
    content: '''
মাগরিবের সময় হওয়া মাত্র দ্রুত ইফতার করা সুন্নাত। রাসূলুল্লাহ (সাল্লাল্লাহু আলাইহি ওয়াসাল্লাম) বলেছেন, "মানুষ যতদিন ইফতারে তাড়াহুড়া করবে, ততদিন তারা কল্যাণের উপর থাকবে।" (সহীহ বুখারী, সহীহ মুসলিম)

ইফতারের সময় পঠিত দোয়া:

ذَهَبَ الظَّمَأُ وَابْتَلَّتِ الْعُرُوقُ وَثَبَتَ الْأَجْرُ إِنْ شَاءَ اللَّهُ

অর্থ: পিপাসা দূর হলো, শিরা-উপশিরা সিক্ত হলো এবং আল্লাহ চাইলে সওয়াব নিশ্চিত হলো। (সুনানে আবু দাউদ)

খেজুর দিয়ে ইফতার করা সুন্নাত, না থাকলে পানি দিয়ে ইফতার করা যায়।
''',
  ),
  const FastingTopicData(
    title: 'রোজা ভঙ্গের কারণসমূহ',
    subtitle: 'যা থেকে বিরত থাকতে হয়',
    emoji: '🚫',
    color: Colors.red,
    content: '''
ইচ্ছাকৃতভাবে পানাহার করা, ধূমপান করা, স্বেচ্ছায় বমি করা এবং স্বামী-স্ত্রীর সহবাস রোজা ভঙ্গের প্রধান কারণ।

ভুলবশত পানাহার করে ফেললে রোজা ভাঙে না — মনে পড়ামাত্র বিরত থাকতে হবে। রাসূলুল্লাহ (সাল্লাল্লাহু আলাইহি ওয়াসাল্লাম) বলেছেন, "যে ব্যক্তি ভুলে পানাহার করে ফেলল, সে যেন রোজা পূর্ণ করে; কেননা আল্লাহই তাকে খাইয়েছেন ও পান করিয়েছেন।" (সহীহ বুখারী, সহীহ মুসলিম)

কোন কারণে রোজা ভাঙলে কাযা করতে হবে কিনা, নাকি কাফফারাও দিতে হবে — এটা নির্দিষ্ট পরিস্থিতির উপর নির্ভর করে, তাই নির্ভরযোগ্য আলেমের কাছ থেকে জেনে নেওয়া উচিত।
''',
  ),
  const FastingTopicData(
    title: 'লাইলাতুল কদর',
    subtitle: 'হাজার মাসের চেয়ে উত্তম রাত',
    emoji: '✨',
    color: Colors.indigo,
    content: '''
আল্লাহ তাআলা বলেন, "লাইলাতুল কদর হাজার মাস অপেক্ষা উত্তম।" (সূরা কদর, আয়াত ৩)

রমজানের শেষ দশকের বিজোড় রাতগুলোতে (২১, ২৩, ২৫, ২৭, ২৯ তারিখের রাত) এই রাত খোঁজার জন্য রাসূলুল্লাহ (সাল্লাল্লাহু আলাইহি ওয়াসাল্লাম) নির্দেশ দিয়েছেন।

এই রাতে বেশি বেশি দোয়া, ইস্তেগফার ও নফল ইবাদতে মশগুল থাকা উত্তম। আয়েশা (রাযিয়াল্লাহু আনহা) বর্ণিত একটি বিশেষ দোয়া:

اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي

অর্থ: হে আল্লাহ, তুমি ক্ষমাশীল, ক্ষমা করতে ভালোবাসো, অতএব আমাকে ক্ষমা করে দাও। (সুনানে তিরমিযী)
''',
  ),
  const FastingTopicData(
    title: 'ই\'তিকাফ',
    subtitle: 'মসজিদে অবস্থান করে ইবাদত',
    emoji: '🕌',
    color: Colors.green,
    content: '''
ই'তিকাফ হলো নির্দিষ্ট নিয়তে মসজিদে অবস্থান করে ইবাদতে মগ্ন থাকা। রমজানের শেষ দশকে ই'তিকাফ করা সুন্নাতে মুআক্কাদা (রাসূলুল্লাহ প্রতি বছর নিয়মিত পালন করতেন)।

ই'তিকাফরত অবস্থায় প্রয়োজন ছাড়া মসজিদ থেকে বের হওয়া যায় না। এই সময়ে বেশি বেশি নামায, কুরআন তিলাওয়াত, জিকির ও দোয়ায় মশগুল থাকা উত্তম।

ই'তিকাফের নির্দিষ্ট মাসআলা মাযহাব অনুযায়ী কিছুটা ভিন্ন হতে পারে, বিস্তারিত জানতে স্থানীয় আলেমের সাহায্য নিন।
''',
  ),
  const FastingTopicData(
    title: 'কাযা ও ফিদইয়া',
    subtitle: 'ছুটে যাওয়া রোজার বিধান',
    emoji: '🔄',
    color: Colors.brown,
    content: '''
অসুস্থতা, সফর, ঋতুস্রাব বা অন্য বৈধ কারণে রোজা ছুটে গেলে পরবর্তীতে (পরের রমজানের পূর্বে) তা কাযা আদায় করতে হয়।

যে ব্যক্তি বার্ধক্য বা স্থায়ী অসুস্থতার কারণে রোজা রাখতে একেবারেই অক্ষম, তার জন্য প্রতিটি রোজার পরিবর্তে একজন মিসকীনকে খাবার খাওয়ানো (ফিদইয়া) দেওয়ার বিধান রয়েছে।

নির্দিষ্ট পরিমাণ ও পদ্ধতি অঞ্চল ও মাযহাবভেদে কিছুটা ভিন্ন হতে পারে — সঠিক পরিমাণ জানতে নির্ভরযোগ্য আলেমের পরামর্শ নিন।
''',
  ),
];

class FastingSection extends StatelessWidget {
  const FastingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(isDark),
        const SizedBox(height: 16),
        // ← নতুন দু'আ বাটন
        _buildDuaButton(context, isDark),
        const SizedBox(height: 12),
        ...fastingTopics.map(
          (topic) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildTopicCard(context, topic, isDark),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // emoji-based icon badge — একটা হালকা রঙের গোল ব্যাকগ্রাউন্ডে emoji
  Widget _buildEmojiBadge(String emoji, MaterialColor color, bool isDark) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.20 : 0.13),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      alignment: Alignment.center,
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  // ← নতুন দু'আ বাটন widget
  Widget _buildDuaButton(BuildContext context, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const FastingDuaSection(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            _buildEmojiBadge('🤲', Colors.teal, isDark),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "দু'আ",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'রমযান ও ঈদের দু\'আ সমূহ',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF064E3B), Color(0xFF0F2E2A)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🌙', style: TextStyle(fontSize: 22)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'রোজা — ফজিলত ও আমল',
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
            'রোজার গুরুত্বপূর্ণ বিষয়গুলো এক নজরে জেনে নিন',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    FastingTopicData topic,
    bool isDark,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FastingTopicPage(topic: topic),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          children: [
            _buildEmojiBadge(topic.emoji, topic.color, isDark),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topic.subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class FastingTopicPage extends StatelessWidget {
  final FastingTopicData topic;

  const FastingTopicPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = topic.color;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF042F2E),
        foregroundColor: Colors.white,
        title: Text(
          topic.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color[isDark ? 900 : 50],
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Text(topic.emoji, style: const TextStyle(fontSize: 44)),
                const SizedBox(height: 10),
                Text(
                  topic.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  topic.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color[isDark ? 100 : 800],
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
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0),
              ),
            ),
            child: Text(
              topic.content,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
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
