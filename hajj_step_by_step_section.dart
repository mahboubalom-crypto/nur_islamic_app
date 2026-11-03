import 'package:flutter/material.dart';

class HajjStep {
  final String title;
  final String description;
  final List<String> tasks;

  const HajjStep({
    required this.title,
    required this.description,
    required this.tasks,
  });
}

final List<HajjStep> hajjSteps = [
  const HajjStep(
    title: '১. ইহরাম বাঁধা',
    description: 'মিকাত থেকে ইহরাম বাঁধার প্রস্তুতি',
    tasks: [
      'গোসল করা',
      'ইহরামের কাপড় পরা',
      'দুই রাকাত নফল নামাজ পড়া',
      'নিয়ত করা',
      'তালবিয়া পাঠ করা (লাব্বাইক আল্লাহুম্মা লাব্বাইক...)',
    ],
  ),
  const HajjStep(
    title: '২. মক্কায় প্রবেশ',
    description: 'মসজিদুল হারামে প্রবেশ ও তাওয়াফ',
    tasks: [
      'হারাম শরীফে প্রবেশের দোয়া পড়া',
      'তাওয়াফে কুদুম করা (৭ চক্কর)',
      'হাজরে আসওয়াদে চুমু/ইশারা করা',
      'মাকামে ইব্রাহিমে দুই রাকাত নামাজ',
      'সাফা-মারওয়া সাঈ করা (৭ বার)',
    ],
  ),
  const HajjStep(
    title: '৩. মিনায় অবস্থান',
    description: '৮ জিলহজ্জ মিনায় রাত্রিযাপন',
    tasks: [
      'ফজরের পর মিনার উদ্দেশ্যে রওয়ানা',
      'মিনায় তাঁবুতে অবস্থান',
      'পাঁচ ওয়াক্ত নামাজ কসর করে আদায়',
      'তালবিয়া ও জিকির পাঠ',
    ],
  ),
  const HajjStep(
    title: '৪. আরাফার ময়দান',
    description: '৯ জিলহজ্জ আরাফায় অবস্থান (হজ্জের মূল রুকন)',
    tasks: [
      'সূর্যোদয়ের পর আরাফায় যাওয়া',
      'জোহর ও আসর একসাথে কসর করে পড়া',
      'দোয়া ও ইস্তিগফারে মশগুল থাকা',
      'সূর্যাস্তের পর মুজদালিফার উদ্দেশ্যে রওয়ানা',
    ],
  ),
  const HajjStep(
    title: '৫. মুজদালিফায় রাত্রিযাপন',
    description: 'মুজদালিফায় রাত কাটানো ও কংকর সংগ্রহ',
    tasks: [
      'মাগরিব ও ইশা একসাথে পড়া',
      'খোলা আকাশের নিচে রাত কাটানো',
      'রমির জন্য ৪৯/৭০টি কংকর সংগ্রহ',
      'ফজরের পর মিনার উদ্দেশ্যে রওয়ানা',
    ],
  ),
  const HajjStep(
    title: '৬. কংকর নিক্ষেপ ও কুরবানি',
    description: '১০ জিলহজ্জ ঈদের দিনের আমল',
    tasks: [
      'বড় জামরায় ৭টি কংকর নিক্ষেপ',
      'কুরবানি করা',
      'মাথা মুণ্ডন বা চুল ছোট করা',
      'ইহরাম খোলা (প্রথম হালাল)',
      'মক্কায় গিয়ে তাওয়াফে জিয়ারাত করা',
      'সাফা-মারওয়া সাঈ করা',
    ],
  ),
  const HajjStep(
    title: '৭. আইয়ামে তাশরিক',
    description: '১১, ১২, ১৩ জিলহজ্জ মিনায় কংকর নিক্ষেপ',
    tasks: [
      'মিনায় রাত্রিযাপন',
      'প্রতিদিন তিনটি জামরায় ৭টি করে কংকর (মোট ২১টি)',
      'সূর্য ঢলার পর রমি করা',
      '১২ তারিখ সূর্যাস্তের আগে মিনা ছাড়লে হজ্জ সম্পন্ন',
    ],
  ),
  const HajjStep(
    title: '৮. তাওয়াফে বিদা',
    description: 'মক্কা ছাড়ার আগে বিদায়ী তাওয়াফ',
    tasks: [
      'মক্কা ছেড়ে যাওয়ার আগে ৭ চক্কর তাওয়াফ',
      'মাকামে ইব্রাহিমে দুই রাকাত নামাজ',
      'জমজম পান করা',
      'বিদায়ী দোয়া পড়া',
    ],
  ),
];

class HajjStepByStepSection extends StatefulWidget {
  const HajjStepByStepSection({super.key});

  @override
  State<HajjStepByStepSection> createState() => _HajjStepByStepSectionState();
}

class _HajjStepByStepSectionState extends State<HajjStepByStepSection> {
  final Map<String, bool> _checkedTasks = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        title: const Text(
          'ধাপে ধাপে হজ্জ গাইড',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          ...hajjSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildStepCard(step, index, isDark),
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
          const Text('✅', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'হজ্জের প্রতিটি ধাপ সম্পন্ন করার সাথে সাথে টিক চিহ্ন দিন',
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

  Widget _buildStepCard(HajjStep step, int index, bool isDark) {
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
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        leading: CircleAvatar(
          backgroundColor: Colors.green[700],
          child: Text(
            '${index + 1}',
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          step.title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          step.description,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[600],
            fontSize: 11,
          ),
        ),
        children: step.tasks.map((task) {
          final key = '${step.title}_$task';
          final isChecked = _checkedTasks[key] ?? false;

          return CheckboxListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: isChecked,
            onChanged: (val) {
              setState(() {
                _checkedTasks[key] = val ?? false;
              });
            },
            title: Text(
              task,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 13,
                decoration: isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
            activeColor: Colors.green[700],
          );
        }).toList(),
      ),
    );
  }
}
