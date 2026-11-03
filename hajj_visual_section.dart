import 'package:flutter/material.dart';

class HajjPlace {
  final String name;
  final String description;
  final String emoji;

  const HajjPlace({
    required this.name,
    required this.description,
    required this.emoji,
  });
}

final List<HajjPlace> hajjPlaces = [
  const HajjPlace(
    name: 'মসজিদুল হারাম',
    description: 'পবিত্র কাবা শরীফ ও তাওয়াফের স্থান',
    emoji: '🕋',
  ),
  const HajjPlace(
    name: 'সাফা ও মারওয়া',
    description: 'সাঈ করার দুটি পাহাড়',
    emoji: '⛰️',
  ),
  const HajjPlace(
    name: 'মিনা',
    description: 'তাঁবুর শহর, হজ্জের সময় অবস্থানের স্থান',
    emoji: '⛺',
  ),
  const HajjPlace(
    name: 'আরাফার ময়দান',
    description: 'হজ্জের সবচেয়ে গুরুত্বপূর্ণ স্থান',
    emoji: '🏔️',
  ),
  const HajjPlace(
    name: 'মুজদালিফা',
    description: 'খোলা আকাশের নিচে রাত্রিযাপনের স্থান',
    emoji: '🌙',
  ),
  const HajjPlace(
    name: 'জামরাত (কংকর নিক্ষেপ)',
    description: 'শয়তানকে কংকর মারার স্থান',
    emoji: '🎯',
  ),
  const HajjPlace(
    name: 'জমজম কূপ',
    description: 'পবিত্র জমজম পানির উৎস',
    emoji: '💧',
  ),
  const HajjPlace(
    name: 'মসজিদে নববী',
    description: 'মদিনায় রাসূল (সা.) এর মসজিদ',
    emoji: '🕌',
  ),
];

class HajjVisualSection extends StatelessWidget {
  const HajjVisualSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFEEF2F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF064E3B),
        foregroundColor: Colors.white,
        title: const Text(
          'সচিত্র হজ্জ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(isDark),
          const SizedBox(height: 16),
          ...hajjPlaces.map((place) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPlaceCard(place, isDark),
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
          const Text('🗺️', style: TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'হজ্জের গুরুত্বপূর্ণ স্থানসমূহের ম্যাপ ও বিবরণ',
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

  Widget _buildPlaceCard(HajjPlace place, bool isDark) {
    return Container(
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(place.emoji, style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.name,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place.description,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
