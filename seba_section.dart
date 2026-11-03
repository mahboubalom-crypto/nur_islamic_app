import 'package:flutter/material.dart';

class SebaSection extends StatelessWidget {
  final void Function(String tab) setActiveTab;

  const SebaSection({super.key, required this.setActiveTab});

  // 'tab' key থাকলে ট্যাপ করলে সেই সেকশনে নেভিগেট করবে;
  // না থাকলে এখনো "শীঘ্রই যুক্ত করা হবে" দেখাবে।
  static const List<Map<String, String>> _sebaModules = [
    {
      'title': 'যাকাত ফিতরা',
      'icon': '💰',
      'tab': 'zakat'
    }, // <-- এখানে 'tab': 'zakat' যুক্ত করা হয়েছে
    {'title': 'বিনিয়োগ', 'icon': '📈'},
    {'title': 'দ্বীনি জিজ্ঞাসা', 'icon': '📞'},
    {'title': 'তালীমে কুইজ', 'icon': '💡'},
    {'title': 'বিবাহ', 'icon': '💍'},
    {'title': 'কেনাকাটা', 'icon': '🛒'},
    {'title': 'চাকরি', 'icon': '💼'},
    {'title': 'সাপোর্ট', 'icon': '🎧'},
    {'title': 'অ্যালার্ম', 'icon': '⏰', 'tab': 'alarm'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('সেবা', isDark),
        const SizedBox(height: 12),
        _buildGrid(isDark, context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _sectionTitle(String title, bool isDark) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.orange[700],
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
      itemCount: _sebaModules.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = _sebaModules[index];
        final tab = item['tab'];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (tab != null) {
              setActiveTab(tab);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${item['title']} — শীঘ্রই যুক্ত করা হবে',
                  ),
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
                  item['icon'] ?? '',
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    item['title'] ?? '',
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
}
