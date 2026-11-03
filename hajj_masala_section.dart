import 'package:flutter/material.dart';

class HajjMasala {
  final String question;
  final String answer;

  const HajjMasala({
    required this.question,
    required this.answer,
  });
}

final List<HajjMasala> hajjMasalaList = [
  const HajjMasala(
    question: 'হজ্জের ফরজ কয়টি?',
    answer:
        'হজ্জের ফরজ ৩টি:\n১. ইহরাম বাঁধা\n২. আরাফার ময়দানে অবস্থান\n৩. তাওয়াফে জিয়ারাত',
  ),
  const HajjMasala(
    question: 'তামাত্তু, কিরান ও ইফরাদ হজ্জের পার্থক্য কী?',
    answer:
        'তামাত্তু: প্রথমে উমরা করে ইহরাম খুলে ফেলা, পরে আবার হজ্জের ইহরাম বাঁধা।\n\nকিরান: একই ইহরামে উমরা ও হজ্জ একসাথে করা।\n\nইফরাদ: শুধু হজ্জের ইহরাম বাঁধা, উমরা না করা।',
  ),
  const HajjMasala(
    question: 'ইহরাম অবস্থায় ভুলে চুল কাটলে কী করতে হবে?',
    answer:
        'ভুলে চুল কাটলে দম (একটি ছাগল কুরবানি) দিতে হবে। তবে অল্প কয়েকটি চুল পড়ে গেলে সদকা দিলেই চলবে।',
  ),
  const HajjMasala(
    question: 'হজ্জে কখন মাথা মুণ্ডন করতে হয়?',
    answer:
        '১০ জিলহজ্জ, কংকর নিক্ষেপ ও কুরবানির পর মাথা মুণ্ডন বা চুল ছোট করতে হয়। পুরুষদের জন্য মুণ্ডন উত্তম, মহিলারা চুলের এক ইঞ্চি কাটবেন।',
  ),
  const HajjMasala(
    question: 'তাওয়াফের সময় হাজরে আসওয়াদে চুমু দেওয়া কি ফরজ?',
    answer:
        'না, এটি সুন্নত। ভিড় থাকলে হাত দিয়ে ইশারা করলেই যথেষ্ট। জোর করে ভিড় ঠেলে গিয়ে অন্যদের কষ্ট দেওয়া ঠিক নয়।',
  ),
  const HajjMasala(
    question: 'সাঈ কি তাওয়াফের সাথে একসাথে করতে হয়?',
    answer:
        'সাঈ তাওয়াফের পরপরই করা উত্তম, তবে বিলম্ব হলেও সমস্যা নেই। তাওয়াফ ও সাঈ-এর মাঝে বিরতি নেওয়া যায়।',
  ),
];

class HajjMasalaSection extends StatelessWidget {
  const HajjMasalaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        title: const Text(
          'মাসআলা',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          ...hajjMasalaList.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMasalaCard(entry.value, entry.key + 1, isDark),
            );
          }),
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
          const Text('❓', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'হজ্জ সংক্রান্ত গুরুত্বপূর্ণ মাসআলা-মাসায়েল',
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

  Widget _buildMasalaCard(HajjMasala masala, int index, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFE2E8F0),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(
            '$index',
            style:
                TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          masala.question,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        children: [
          Text(
            masala.answer,
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
