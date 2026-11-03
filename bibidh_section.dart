import 'package:flutter/material.dart';

class BibidhSection extends StatelessWidget {
  final void Function(String tab) setActiveTab;

  const BibidhSection({super.key, required this.setActiveTab});

  static const List<Map<String, dynamic>> _bibidhModules = [
    {'title': 'কিবলা', 'emoji': '🧭', 'tab': 'qibla'},
    {'title': 'মসজিদ খুঁজি', 'emoji': '📍'},
    {'title': 'আমার মসজিদ', 'emoji': '🕌'},
    {'title': 'আসমাউল হুসনা', 'emoji': '📿', 'tab': 'asmaul_husna'},
    {'title': 'লাইভ', 'emoji': '📺'},
    {'title': 'রোযা', 'emoji': '🌙', 'tab': 'fasting'},
    {'title': 'সুন্নাহ', 'emoji': '☀️', 'tab': 'sunnah'},
    {'title': 'ইসলামিক নাম', 'emoji': '📛', 'tab': 'islamic_names'},
    {'title': 'ক্যালেন্ডার', 'emoji': '📅', 'tab': 'calendar'},
    {'title': 'গুরুত্বপূর্ণ দিন', 'emoji': '⭐', 'tab': 'important_days'},
    {'title': 'বুকমার্ক', 'emoji': '🔖'},
    {'title': 'অন্যান্য', 'emoji': '🔲', 'tab': 'others_settings'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle('বিবিধ', isDark),
          const SizedBox(height: 12),
          _buildGrid(isDark, context),
          const SizedBox(height: 20),
          _buildDonationBanner(isDark),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 24,
          decoration: BoxDecoration(
            color: const Color(0xFF5B2D82),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(bool isDark, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bibidhModules.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = _bibidhModules[index];
        final tab = item['tab'] as String?;
        final emoji = item['emoji'] as String;

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (tab != null) {
              setActiveTab(tab);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['title']} — শীঘ্রই যুক্ত করা হবে'),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    item['title'] as String,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF315B4D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDonationBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F8F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFD1E7DD),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF236B34).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 14, color: Color(0xFF236B34)),
                SizedBox(width: 4),
                Text(
                  'সাদাকায়ে জারিয়াহ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF236B34),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'মুসলিম বাংলার সাথী হন',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'আপনার সাদাকাহর মাধ্যমে মুসলিম বাংলার অগ্রযাত্রার সাথী হন।',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.white70 : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF236B34),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ডোনেশন করুন',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
