import 'package:flutter/material.dart';
import 'namaz_sunnah_section.dart';
import 'sunnah_topics_data.dart';

class SunnahSection extends StatelessWidget {
  final void Function(String tab)? setActiveTab;

  const SunnahSection({super.key, this.setActiveTab});

  static const List<Map<String, String>> _sunnahItems = [
    {'title': 'নামাজ', 'emoji': '🧎'},
    {'title': 'মসজিদে প্রবেশ করা', 'emoji': '🕌'},
    {'title': 'মসজিদ থেকে বের হওয়া', 'emoji': '🕌'},
    {'title': 'টয়লেট / ইস্তিঞ্জা', 'emoji': '🚽'},
    {'title': 'ওযু', 'emoji': '🚰'},
    {'title': 'গোসল', 'emoji': '🚿'},
    {'title': 'তায়াম্মুম', 'emoji': '🤲'},
    {'title': 'ঘুমানো', 'emoji': '😴'},
    {'title': 'ঘুম থেকে ওঠা', 'emoji': '🌅'},
    {'title': 'খানা খাওয়া', 'emoji': '🍽️'},
    {'title': 'পান করা', 'emoji': '🥤'},
    {'title': 'সাহরি', 'emoji': '🍲'},
    {'title': 'ইফতার', 'emoji': '🍛'},
    {'title': 'রামাদান', 'emoji': '🌙'},
    {'title': 'ঈদের দিনের সুন্নত ও আদব', 'emoji': '✉️'},
    {'title': 'ঈদের দিনের মুস্তাহাব', 'emoji': '✉️'},
    {'title': 'কুরবানী / যবেহ', 'emoji': '🐐'},
    {'title': 'রোযার আদব', 'emoji': '🌙'},
    {'title': 'পোশাক পরিধান', 'emoji': '👘'},
    {'title': 'নখ কাটা', 'emoji': '💅'},
    {'title': 'সফর', 'emoji': '🧳'},
    {'title': 'বিবাহ', 'emoji': '💑'},
    {'title': 'মৃত্যুকালীন', 'emoji': '🛏️'},
    {'title': 'জুম\'আর দিন', 'emoji': '🌙'},
    {'title': 'মুনাজাত', 'emoji': '🤲'},
    {'title': 'আযান', 'emoji': '📢'},
    {'title': 'ইকামত', 'emoji': '🕌'},
    {'title': 'মজলিস', 'emoji': '👥'},
    {'title': 'আলাপ-আলোচনা', 'emoji': '💬'},
    {'title': 'নবীদের স্বভাবজাত', 'emoji': '⭐'},
    {'title': 'শিশুর জন্মকালীন', 'emoji': '👶'},
    {'title': 'চুল-দাড়ি', 'emoji': '🧔'},
    {'title': 'ঘরে প্রবেশ', 'emoji': '🏠'},
    {'title': 'ঘর থেকে বের হওয়া', 'emoji': '🚪'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, isDark),
        const SizedBox(height: 14),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _sunnahItems.length,
          itemBuilder: (context, index) {
            final item = _sunnahItems[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildRow(context, item, isDark),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        if (setActiveTab != null)
          IconButton(
            icon: Icon(Icons.arrow_back,
                color: isDark ? Colors.white : const Color(0xFF1F2937)),
            onPressed: () => setActiveTab!('bibidh'),
          )
        else
          const SizedBox(width: 8),
        Expanded(
          child: Text(
            'সুন্নত সমূহ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildRow(
      BuildContext context, Map<String, String> item, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        if (item['title'] == 'নামাজ') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahSection(setActiveTab: setActiveTab),
            ),
          );
          return;
        }
        if (item['title'] == 'মসজিদে প্রবেশ করা') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  NamazSunnahDetailPage(category: masjidEntryCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'মসজিদ থেকে বের হওয়া') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  NamazSunnahDetailPage(category: masjidExitCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'টয়লেট / ইস্তিঞ্জা') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: toiletCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'ওযু') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: wuduCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'গোসল') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: goslCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'তায়াম্মুম') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: tayammumCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'ঘুমানো') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: sleepingCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'ঘুম থেকে ওঠা') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: wakingUpCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'পান করা') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: drinkingCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'খানা খাওয়া') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: eatingCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'সাহরি') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: sahriCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'ইফতার') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: iftarCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'রামাদান') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: ramadanCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'ঈদের দিনের সুন্নত ও আদব') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  NamazSunnahDetailPage(category: eidSunnahCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'ঈদের দিনের মুস্তাহাব') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  NamazSunnahDetailPage(category: eidMustahabCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'কুরবানী / যবেহ') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: qurbaniCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'রোযার আদব') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  NamazSunnahDetailPage(category: rojarAdobCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'পোশাক পরিধান') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: clothingCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'নখ কাটা') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                NamazSunnahDetailPage(category: nailCuttingCategory),
          ));
          return;
        }
        if (item['title'] == 'সফর') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: travelCategory),
          ));
          return;
        }
        if (item['title'] == 'বিবাহ') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: marriageCategory),
          ));
          return;
        }
        if (item['title'] == 'মৃত্যুকালীন') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  NamazSunnahDetailPage(category: deathTimeCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'জুম\'আর দিন') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => NamazSunnahDetailPage(category: jumarDinCategory),
            ),
          );
          return;
        }
        if (item['title'] == 'মুনাজাত') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: munajatCategory),
          ));
          return;
        }
        if (item['title'] == 'আযান') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: azanCategory),
          ));
          return;
        }
        if (item['title'] == 'ইকামত') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: iqamatCategory),
          ));
          return;
        }
        if (item['title'] == 'মজলিস') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: majlisCategory),
          ));
          return;
        }
        if (item['title'] == 'আলাপ-আলোচনা') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) =>
                NamazSunnahDetailPage(category: conversationCategory),
          ));
          return;
        }
        if (item['title'] == 'নবীদের স্বভাবজাত') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: fitrahCategory),
          ));
          return;
        }
        if (item['title'] == 'শিশুর জন্মকালীন') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: newbornCategory),
          ));
          return;
        }
        if (item['title'] == 'চুল-দাড়ি') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: hairBeardCategory),
          ));
          return;
        }
        if (item['title'] == 'ঘরে প্রবেশ') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: enterHomeCategory),
          ));
          return;
        }
        if (item['title'] == 'ঘর থেকে বের হওয়া') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => NamazSunnahDetailPage(category: exitHomeCategory),
          ));
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['title']} — শীঘ্রই যুক্ত করা হবে'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Text(item['emoji'] ?? '', style: const TextStyle(fontSize: 26)),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                item['title'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
