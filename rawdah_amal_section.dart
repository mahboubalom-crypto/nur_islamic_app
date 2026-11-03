import 'package:flutter/material.dart';

class RawdahAmal {
  final String title;
  final String content;
  final String emoji;

  const RawdahAmal({
    required this.title,
    required this.content,
    required this.emoji,
  });
}

final List<RawdahAmal> rawdahAmalList = [
  const RawdahAmal(
    title: 'মসজিদে নববীতে প্রবেশের আদব',
    emoji: '🕌',
    content: '''
মসজিদে নববীতে প্রবেশের সময়:

• ডান পা দিয়ে প্রবেশ করা
• দরূদ শরীফ পড়া
• মসজিদে প্রবেশের দোয়া পড়া:
"বিসমিল্লাহি ওয়াস সালাতু ওয়াস সালামু আলা রাসূলিল্লাহ। আল্লাহুম্মাফতাহ লি আবওয়াবা রাহমাতিক।"

• নিয়ত করা যে, আল্লাহর সন্তুষ্টির জন্য এসেছি
• বিনয় ও ভালোবাসার সাথে প্রবেশ করা
''',
  ),
  const RawdahAmal(
    title: 'রওজা মোবারকে সালাম',
    emoji: '🤍',
    content: '''
রাসূল (সা.) এর রওজায় সালাম দেওয়ার পদ্ধতি:

• রওজার সামনে দাঁড়িয়ে কিবলামুখী হবেন না, রওজার দিকে মুখ করবেন
• নিচু স্বরে বলবেন:
"আসসালামু আলাইকা ইয়া রাসূলাল্লাহ"
"আসসালামু আলাইকা ইয়া নাবিয়াল্লাহ"
"আসসালামু আলাইকা ইয়া হাবিবাল্লাহ"

• তারপর ডানে একটু সরে আবু বকর (রা.) এর কবরে সালাম দিন
• আবার ডানে সরে উমর (রা.) এর কবরে সালাম দিন
• সালাম দীর্ঘ করবেন না, অন্যদের সুযোগ দিন
''',
  ),
  const RawdahAmal(
    title: 'রিয়াজুল জান্নায় নামাজ',
    emoji: '🌟',
    content: '''
রিয়াজুল জান্নাহ — জান্নাতের বাগান:

• রাসূল (সা.) বলেছেন, "আমার ঘর ও মিম্বরের মাঝখানের স্থান জান্নাতের বাগানগুলোর একটি বাগান।"

• সবুজ কার্পেটের এলাকা — এখানে নামাজ পড়া অত্যন্ত ফজিলতপূর্ণ

• ভিড় কম হলে এখানে নফল নামাজ পড়ুন

• ভিড়ে অন্যদের কষ্ট দিয়ে যাওয়া ঠিক নয়

• মসজিদের যেকোনো স্থানে নামাজেই অধিক সওয়াব আছে
''',
  ),
  const RawdahAmal(
    title: 'জান্নাতুল বাকিতে দোয়া',
    emoji: '🌿',
    content: '''
জান্নাতুল বাকি — সাহাবীদের কবরস্থান:

• মসজিদে নববীর পাশে অবস্থিত

• এখানে শায়িত আছেন:
  - উম্মুল মুমিনীনগণ (রাসূলের পত্নীগণ)
  - হজরত ফাতিমা (রা.)
  - হজরত আব্বাস (রা.)
  - হজরত উসমান (রা.)
  - হাজার হাজার সাহাবী

• কবরস্থানে প্রবেশের দোয়া:
"আসসালামু আলাইকুম দারা কাওমিম মুমিনীন।"

• তাদের জন্য দোয়া ও মাগফিরাত কামনা করুন
''',
  ),
  const RawdahAmal(
    title: 'মদিনায় অবস্থানকালীন আমল',
    emoji: '📿',
    content: '''
মদিনায় থাকাকালীন মুস্তাহাব আমলসমূহ:

• প্রতিদিন ৫ ওয়াক্ত মসজিদে নববীতে পড়া

• রাতে তাহাজ্জুদ পড়া — মসজিদে বা হোটেলে

• বেশি বেশি দরূদ শরীফ পড়া

• কুরআন তিলাওয়াত করা

• মসজিদে কুবায় গিয়ে নামাজ পড়া (একটি উমরার সওয়াব)

• উহুদ পাহাড় ও শুহাদাদের কবর জিয়ারত

• মদিনার প্রতিটি মুহূর্ত কাজে লাগান — এ সৌভাগ্য বারবার আসে না
''',
  ),
];

class RawdahAmalSection extends StatelessWidget {
  const RawdahAmalSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        title: const Text(
          'রওজার আমল',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          ...rawdahAmalList.map((amal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildAmalCard(amal, isDark),
              )),
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
      ),
      child: Row(
        children: [
          const Text('🤍', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'মদিনা মুনাওয়ারায় রওজা মোবারক জিয়ারতের আমল ও আদব',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmalCard(RawdahAmal amal, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(amal.emoji, style: const TextStyle(fontSize: 22)),
        ),
        title: Text(
          amal.title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        children: [
          Text(
            amal.content,
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontSize: 13,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
