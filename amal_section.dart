import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmalSection extends StatefulWidget {
  final void Function(String tab) setActiveTab;

  const AmalSection({
    super.key,
    required this.setActiveTab,
  });

  @override
  State<AmalSection> createState() => _AmalSectionState();
}

class _AmalSectionState extends State<AmalSection> {
  // ---- useState(checklist) এর সমতুল্য ----
  Map<String, bool> checklist = {
    'fajr': false,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': false,
    'quran': false,
    'dhikr': false,
    'tahajjud': false,
  };

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('nur_daily_checklist');
    if (saved != null) {
      final decoded = jsonDecode(saved) as Map<String, dynamic>;
      setState(() {
        checklist = decoded.map((k, v) => MapEntry(k, v as bool));
      });
    }
  }

  Future<void> _toggleChecklist(String key) async {
    setState(() {
      checklist[key] = !(checklist[key] ?? false);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nur_daily_checklist', jsonEncode(checklist));
  }

  int get _completedCount => checklist.values.where((v) => v).length;

  // ---- amalModules এর সমতুল্য ----
  final List<Map<String, String>> _amalModules = const [
    {'title': 'নামাজের সময়', 'icon': '🕌', 'tab': 'prayer'},
    {'title': 'তিলাওয়াত', 'icon': '📖', 'tab': 'telawat'},
    {'title': 'দু\'আ', 'icon': '🤲', 'tab': 'dua'},
    {'title': 'তাসবীহ্', 'icon': '📿', 'tab': 'tasbih'},
    {'title': 'আমল ট্র্যাকার', 'icon': '📝', 'tab': 'tracker'},
    {'title': 'হজ্জ ও উমরা', 'icon': '🕋', 'tab': 'hajj'},
  ];

  final List<Map<String, String>> _sebaPreview = const [
    {'title': 'যাকাত ফিতরা', 'icon': '💰'},
    {'title': 'বিনিয়োগ', 'icon': '📈'},
    {'title': 'দ্বীনি জিজ্ঞাসা', 'icon': '📞'},
    {'title': 'তালীমে কুইজ', 'icon': '💡'},
    {'title': 'বিবাহ', 'icon': '💍'},
    {'title': 'কেনাকাটা', 'icon': '🛒'},
    {'title': 'চাকরি', 'icon': '💼'},
    {'title': 'সাপোর্ট', 'icon': '🎧'},
  ];

  final List<Map<String, String>> _checklistItems = const [
    {'key': 'fajr', 'label': 'ফজর সালাত'},
    {'key': 'dhuhr', 'label': 'যোহর সালাত'},
    {'key': 'asr', 'label': 'আসর সালাত'},
    {'key': 'maghrib', 'label': 'মাগরিব সালাত'},
    {'key': 'isha', 'label': 'এশা সালাত'},
    {'key': 'tahajjud', 'label': 'তাহাজ্জুদ সালাত'},
    {'key': 'quran', 'label': 'কোরআন তিলাওয়াত'},
    {'key': 'dhikr', 'label': 'সকাল-সন্ধ্যার জিকির'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('আমল', isDark),
        const SizedBox(height: 12),
        _buildGrid(_amalModules, isDark,
            onTap: (tab) => widget.setActiveTab(tab)),
        const SizedBox(height: 18),
        _sectionTitle('সেবা', isDark),
        const SizedBox(height: 12),
        _buildGrid(_sebaPreview, isDark,
            onTap: (_) => widget.setActiveTab('seba')),
        const SizedBox(height: 18),
        _buildChecklistCard(isDark),
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
            color: Colors.green[800],
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

  Widget _buildGrid(
    List<Map<String, String>> items,
    bool isDark, {
    required void Function(String tab) onTap,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTap(item['tab'] ?? 'seba'),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['icon'] ?? '', style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text(
                  item['title'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChecklistCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'আজকের আমল চেকলিস্ট',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? Colors.green[950] : Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$_completedCount / 8 সম্পন্ন',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.green[300] : Colors.green[800]),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _checklistItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.6,
            ),
            itemBuilder: (context, index) {
              final item = _checklistItems[index];
              final key = item['key']!;
              final isChecked = checklist[key] ?? false;

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _toggleChecklist(key),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isChecked
                        ? (isDark
                            ? Colors.green[950]?.withOpacity(0.8)
                            : Colors.green[50])
                        : (isDark ? Colors.grey[900] : Colors.grey[50]),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isChecked
                          ? Colors.green
                          : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isChecked ? Icons.check_circle : Icons.circle_outlined,
                        size: 16,
                        color: isChecked ? Colors.green[600] : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          item['label']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isChecked
                                ? (isDark
                                    ? Colors.green[300]
                                    : Colors.green[800])
                                : (isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
