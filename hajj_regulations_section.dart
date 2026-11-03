import 'package:flutter/material.dart';

class HajjRuleTopic {
  final String title;
  final String subtitle;
  final String emoji;
  final MaterialColor color;
  final String content;

  const HajjRuleTopic({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.content,
  });
}

final List<HajjRuleTopic> hajjRuleTopics = [
  const HajjRuleTopic(
    title: 'ইহরামের নিষিদ্ধ কাজসমূহ',
    subtitle: 'ইহরাম অবস্থায় যা থেকে বিরত থাকতে হয়',
    emoji: '🚫',
    color: Colors.red,
    content: '''
ইহরাম বাঁধার পর নিচের কাজগুলো থেকে বিরত থাকা ওয়াজিব:

সেলাইযুক্ত কাপড় পরা (পুরুষদের জন্য) — মাথা ঢাকা কাপড় বা জুতা যা পায়ের উপরের অংশ ঢেকে রাখে।

সুগন্ধি ব্যবহার করা — শরীরে বা কাপড়ে আতর/পারফিউম লাগানো।

চুল বা নখ কাটা — ইহরাম অবস্থায় শরীরের কোনো চুল বা নখ কাটা নিষিদ্ধ।

শিকার করা — স্থলভাগের বন্য প্রাণী শিকার করা বা শিকারে সহযোগিতা করা।

বিবাহ বন্ধনে আবদ্ধ হওয়া — ইহরাম অবস্থায় বিয়ে করা বা করানো নিষিদ্ধ।

স্বামী-স্ত্রীর সহবাস ও এর পূর্বপ্রস্তুতিমূলক কাজ — সম্পূর্ণ ইহরামকালীন নিষিদ্ধ।

ঝগড়া-বিবাদ ও অশ্লীল কথা বলা — আল্লাহ তাআলা বলেন, "হজ্জ (নির্দিষ্ট) কয়েক মাসে, যে ব্যক্তি এর মধ্যে হজ্জ করার সংকল্প করে, তার জন্য হজ্জের মধ্যে স্ত্রী-সহবাস, অশ্লীল আচরণ ও ঝগড়া-বিবাদ নিষিদ্ধ।" (সূরা বাকারা, আয়াত ১৯৭)

নারীদের ক্ষেত্রে শুধু মুখমণ্ডল ঢাকা নিকাব ও হাতের গ্লাভস পরা নিষিদ্ধ — বাকি স্বাভাবিক পোশাক পরতে পারবেন।
''',
  ),
  const HajjRuleTopic(
    title: 'দম (কুরবানি) ওয়াজিব হওয়ার কারণ',
    subtitle: 'কোন কোন ক্ষেত্রে দম দিতে হয়',
    emoji: '🐑',
    color: Colors.orange,
    content: '''
"দম" অর্থ একটি পশু (সাধারণত ছাগল/ভেড়া) কুরবানি করা, যা নির্দিষ্ট কিছু ভুল বা ত্রুটির কাফফারা হিসেবে ওয়াজিব হয়।

প্রধান কারণগুলো:

তামাত্তু বা কিরান হজ্জ পালনকারী — যারা উমরা ও হজ্জ একত্রে বা পরপর আদায় করেন, তাদের উপর দম ওয়াজিব হয় (সামর্থ্য না থাকলে ১০টি রোজা রাখার বিধান)।

ইহরামের কোনো নিষিদ্ধ কাজ লঙ্ঘন করলে — যেমন সেলাইযুক্ত কাপড় পরা, সুগন্ধি ব্যবহার করা।

নির্দিষ্ট মিকাত অতিক্রম করে ইহরাম ছাড়া প্রবেশ করলে।

কোনো ওয়াজিব আমল (যেমন রমি, কঙ্কর নিক্ষেপ) ছুটে গেলে বা দেরিতে আদায় করলে।

আল্লাহ তাআলা বলেন, "...তোমাদের মধ্যে যে ব্যক্তি অসুস্থ হয় অথবা তার মাথায় কোনো কষ্ট থাকে (চুল কামানোর প্রয়োজন হয়), তবে তাকে ফিদইয়া দিতে হবে — রোজা, সদকা অথবা কুরবানির মাধ্যমে।" (সূরা বাকারা, আয়াত ১৯৬)

দমের সঠিক ধরন ও পরিমাণ পরিস্থিতিভেদে ভিন্ন হতে পারে বলে, নিজের ক্ষেত্রে প্রযোজ্য নিয়ম নির্ভরযোগ্য আলেম বা হজ্জ গাইডের কাছ থেকে নিশ্চিত হয়ে নেওয়া উচিত।
''',
  ),
  const HajjRuleTopic(
    title: 'সদকার মাধ্যমে কাফফারা',
    subtitle: 'ছোট ভুলের জন্য সদকা দেওয়ার বিধান',
    emoji: '🤲',
    color: Colors.teal,
    content: '''
তুলনামূলক ছোট কিছু ভুলের ক্ষেত্রে পূর্ণ দমের পরিবর্তে সদকা (খাদ্য দান) দিয়েও কাফফারা আদায় করা যায় — বিশেষত যেখানে ক্ষতি সীমিত বা অনিচ্ছাকৃত।

উদাহরণস্বরূপ:

অসাবধানতাবশত ইহরামের ছোট কোনো নিয়ম ভঙ্গ হলে।

নির্দিষ্ট কিছু ওয়াজিব বিলম্বে আদায় করলে, ওজর থাকা সাপেক্ষে।

সদকার পরিমাণ ও পদ্ধতি নির্দিষ্ট পরিস্থিতির উপর নির্ভর করে — কোনো নির্দিষ্ট সংখ্যা এখানে উল্লেখ না করে, প্রতিটি ক্ষেত্রে একজন অভিজ্ঞ আলেমের থেকে সঠিক পরিমাণ ও পদ্ধতি জেনে নেওয়াই উত্তম, যাতে কাফফারা সঠিকভাবে আদায় হয়।
''',
  ),
  const HajjRuleTopic(
    title: 'অনুমোদিত কাজসমূহ',
    subtitle: 'ইহরাম অবস্থায় যা করা যায়',
    emoji: '✅',
    color: Colors.green,
    content: '''
ইহরাম অবস্থায়ও কিছু কাজ সম্পূর্ণ অনুমোদিত, যেগুলো নিয়ে অনেকের মধ্যে বিভ্রান্তি থাকে:

গোসল করা ও শরীর পরিষ্কার রাখা — সুগন্ধিযুক্ত সাবান এড়িয়ে স্বাভাবিকভাবে গোসল করা যায়।

ছাতা বা কাপড় দিয়ে রোদ থেকে বাঁচা — মাথা সরাসরি কাপড় দিয়ে না ঢেকে ছায়ার ব্যবস্থা করা যায়।

আহত হলে ব্যান্ডেজ বা ওষুধ ব্যবহার করা — প্রয়োজনে চিকিৎসা নেওয়া নিষিদ্ধ নয়।

ইহরামের চাদর বদলানো বা ধোয়া — একাধিকবার পরিষ্কার ইহরাম পরা যায়।

কথা বলা, কেনাকাটা করা, প্রয়োজনীয় লেনদেন করা — স্বাভাবিক জীবনযাত্রা চলতে পারে, শুধু নিষিদ্ধ কাজগুলো বাদে।

বিস্তারিত পরিস্থিতিতে দ্বিধা থাকলে সেখানে উপস্থিত অভিজ্ঞ গাইড বা আলেমের কাছ থেকে নিশ্চিত হয়ে নেওয়া সবচেয়ে নিরাপদ।
''',
  ),
];

class HajjRegulationsSection extends StatelessWidget {
  const HajjRegulationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        title: const Text(
          'বিধিমালা',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          ...hajjRuleTopics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTopicCard(context, topic, isDark),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          const Text('ℹ️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'অনুমোদিত, অননুমোদিত, দম ও সদকার বিস্তারিত নিয়মকানুন — '
              'নির্দিষ্ট পরিস্থিতিতে সবসময় একজন অভিজ্ঞ আলেমের পরামর্শ নিন।',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    HajjRuleTopic topic,
    bool isDark,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HajjRuleDetailPage(topic: topic),
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
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: topic.color.withValues(alpha: isDark ? 0.20 : 0.13),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: topic.color.withValues(alpha: 0.3)),
              ),
              alignment: Alignment.center,
              child: Text(topic.emoji, style: const TextStyle(fontSize: 24)),
            ),
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

class HajjRuleDetailPage extends StatelessWidget {
  final HajjRuleTopic topic;

  const HajjRuleDetailPage({super.key, required this.topic});

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
