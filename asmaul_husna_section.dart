import 'package:flutter/material.dart';

class AsmaulHusnaSection extends StatelessWidget {
  final void Function(String tab)? setActiveTab;

  const AsmaulHusnaSection({super.key, this.setActiveTab});

  static const List<Map<String, String>> _names = [
    {'arabic': 'الله', 'bangla': 'আল্লাহ', 'meaning': 'একমাত্র ইলাহ'},
    {'arabic': 'الرَّحْمَٰن', 'bangla': 'আর-রাহমান', 'meaning': 'পরম করুণাময়'},
    {'arabic': 'الرَّحِيم', 'bangla': 'আর-রাহীম', 'meaning': 'অসীম দয়ালু'},
    {'arabic': 'الْمَلِك', 'bangla': 'আল-মালিক', 'meaning': 'পরম অধিপতি'},
    {'arabic': 'الْقُدُّوس', 'bangla': 'আল-কুদ্দুস', 'meaning': 'পরম পবিত্র'},
    {'arabic': 'السَّلَام', 'bangla': 'আস-সালাম', 'meaning': 'শান্তির উৎস'},
    {
      'arabic': 'الْمُؤْمِن',
      'bangla': 'আল-মু\'মিন',
      'meaning': 'নিরাপত্তা দানকারী'
    },
    {
      'arabic': 'الْمُهَيْمِن',
      'bangla': 'আল-মুহাইমিন',
      'meaning': 'রক্ষণাবেক্ষণকারী'
    },
    {'arabic': 'الْعَزِيز', 'bangla': 'আল-আযীয', 'meaning': 'পরাক্রমশালী'},
    {'arabic': 'الْجَبَّار', 'bangla': 'আল-জাব্বার', 'meaning': 'পরম শক্তিধর'},
    {
      'arabic': 'الْمُتَكَبِّر',
      'bangla': 'আল-মুতাকাব্বির',
      'meaning': 'মহিমান্বিত'
    },
    {'arabic': 'الْخَالِق', 'bangla': 'আল-খালিক', 'meaning': 'স্রষ্টা'},
    {'arabic': 'الْبَارِئ', 'bangla': 'আল-বারি', 'meaning': 'সৃষ্টিকর্তা'},
    {'arabic': 'الْمُصَوِّر', 'bangla': 'আল-মুসাওবির', 'meaning': 'রূপদানকারী'},
    {'arabic': 'الْغَفَّار', 'bangla': 'আল-গাফফার', 'meaning': 'পরম ক্ষমাশীল'},
    {'arabic': 'الْقَهَّار', 'bangla': 'আল-কাহহার', 'meaning': 'পরাভূতকারী'},
    {'arabic': 'الْوَهَّاب', 'bangla': 'আল-ওয়াহহাব', 'meaning': 'দানশীল'},
    {'arabic': 'الرَّزَّاق', 'bangla': 'আর-রাযযাক', 'meaning': 'রিযিকদাতা'},
    {'arabic': 'الْفَتَّاح', 'bangla': 'আল-ফাত্তাহ', 'meaning': 'বিজয়দানকারী'},
    {'arabic': 'اَلْعَلِيْم', 'bangla': 'আল-আলীম', 'meaning': 'সর্বজ্ঞ'},
    {'arabic': 'الْقَابِض', 'bangla': 'আল-কাবিদ', 'meaning': 'সংকোচনকারী'},
    {'arabic': 'الْبَاسِط', 'bangla': 'আল-বাসিত', 'meaning': 'সম্প্রসারণকারী'},
    {'arabic': 'الْخَافِض', 'bangla': 'আল-খাফিদ', 'meaning': 'অবনতকারী'},
    {'arabic': 'الرَّافِع', 'bangla': 'আর-রাফি', 'meaning': 'উন্নতকারী'},
    {'arabic': 'الْمُعِزّ', 'bangla': 'আল-মুইয্য', 'meaning': 'সম্মানদাতা'},
    {'arabic': 'المُذِلّ', 'bangla': 'আল-মুযিল', 'meaning': 'অপমানকারী'},
    {'arabic': 'السَّمِيع', 'bangla': 'আস-সামি', 'meaning': 'সর্বশ্রোতা'},
    {'arabic': 'الْبَصِير', 'bangla': 'আল-বাসীর', 'meaning': 'সর্বদ্রষ্টা'},
    {'arabic': 'الْحَكَم', 'bangla': 'আল-হাকাম', 'meaning': 'বিচারক'},
    {'arabic': 'الْعَدْل', 'bangla': 'আল-আদল', 'meaning': 'ন্যায়পরায়ণ'},
    {'arabic': 'اللَّطِيف', 'bangla': 'আল-লতীফ', 'meaning': 'সূক্ষ্মদর্শী'},
    {'arabic': 'الْخَبِير', 'bangla': 'আল-খবীর', 'meaning': 'সর্বজ্ঞাত'},
    {'arabic': 'الْحَلِيم', 'bangla': 'আল-হালীম', 'meaning': 'সহনশীল'},
    {'arabic': 'الْعَظِيم', 'bangla': 'আল-আযীম', 'meaning': 'মহান'},
    {'arabic': 'الْغَفُور', 'bangla': 'আল-গাফুর', 'meaning': 'ক্ষমাকারী'},
    {'arabic': 'الشَّكُور', 'bangla': 'আশ-শাকুর', 'meaning': 'গুণগ্রাহী'},
    {'arabic': 'الْعَلِيّ', 'bangla': 'আল-আলিয়্যু', 'meaning': 'সমুন্নত'},
    {'arabic': 'الْكَبِير', 'bangla': 'আল-কাবীর', 'meaning': 'সুমহান'},
    {
      'arabic': 'الْحَفِيظ',
      'bangla': 'আল-হাফিয',
      'meaning': 'রক্ষণাবেক্ষণকারী'
    },
    {'arabic': 'المُقِيت', 'bangla': 'আল-মুকীত', 'meaning': 'অন্নদাতা'},
    {'arabic': 'الْحسِيب', 'bangla': 'আল-হাসীব', 'meaning': 'হিসাবগ্রহণকারী'},
    {'arabic': 'الْجَلِيل', 'bangla': 'আল-জালীল', 'meaning': 'মর্যাদাবান'},
    {'arabic': 'الْكَرِيم', 'bangla': 'আল-কারীম', 'meaning': 'মহানুভব'},
    {'arabic': 'الرَّقِيب', 'bangla': 'আর-রাকীব', 'meaning': 'তত্ত্বাবধায়ক'},
    {'arabic': 'الْمُجِيب', 'bangla': 'আল-মুজীব', 'meaning': 'সাড়াদানকারী'},
    {
      'arabic': 'الْوَاسِع',
      'bangla': 'আল-ওয়াসি',
      'meaning': 'প্রশস্ততাদানকারী'
    },
    {'arabic': 'الْحَكِيم', 'bangla': 'আল-হাকীম', 'meaning': 'প্রজ্ঞাময়'},
    {'arabic': 'الْوَدُود', 'bangla': 'আল-ওয়াদুদ', 'meaning': 'স্নেহপরায়ণ'},
    {'arabic': 'الْمَجِيد', 'bangla': 'আল-মাজীদ', 'meaning': 'গৌরবময়'},
    {'arabic': 'الْبَاعِث', 'bangla': 'আল-বাইস', 'meaning': 'পুনরুত্থানকারী'},
    {'arabic': 'الشَّهِيد', 'bangla': 'আশ-শাহীদ', 'meaning': 'সাক্ষী'},
    {'arabic': 'الْحَقّ', 'bangla': 'আল-হাক্ব', 'meaning': 'সত্য'},
    {'arabic': 'الْوَكِيل', 'bangla': 'আল-ওয়াকীল', 'meaning': 'কর্মবিধায়ক'},
    {'arabic': 'الْقَوِيّ', 'bangla': 'আল-কাবিয়্যু', 'meaning': 'শক্তিমান'},
    {'arabic': 'الْمَتِين', 'bangla': 'আল-মাতীন', 'meaning': 'সুদৃঢ়'},
    {'arabic': 'الْوَلِيّ', 'bangla': 'আল-ওয়ালিয়্যু', 'meaning': 'অভিভাবক'},
    {'arabic': 'الْحَمِيد', 'bangla': 'আল-হামীদ', 'meaning': 'প্রশংসিত'},
    {
      'arabic': 'الْمُحْصِي',
      'bangla': 'আল-মুহসী',
      'meaning': 'সমস্ত হিসাবকারী'
    },
    {'arabic': 'الْمُبْدِئ', 'bangla': 'আল-মুবদি', 'meaning': 'সূচনাকারী'},
    {
      'arabic': 'الْمُعِيد',
      'bangla': 'আল-মু\'ঈদ',
      'meaning': 'পুনরাবৃত্তিকারী'
    },
    {'arabic': 'الْمُحْيِي', 'bangla': 'আল-মুহয়ী', 'meaning': 'জীবনদানকারী'},
    {'arabic': 'اَلْمُمِيت', 'bangla': 'আল-মুমীত', 'meaning': 'মৃত্যুদানকারী'},
    {'arabic': 'الْحَيّ', 'bangla': 'আল-হাইয়্যু', 'meaning': 'চিরঞ্জীব'},
    {'arabic': 'الْقَيُّوم', 'bangla': 'আল-কাইয়্যুম', 'meaning': 'চিরস্থায়ী'},
    {'arabic': 'الْوَاجِد', 'bangla': 'আল-ওয়াজিদ', 'meaning': 'অভাবমুক্ত'},
    {'arabic': 'الْمَاجِد', 'bangla': 'আল-মাজিদ', 'meaning': 'গৌরবান্বিত'},
    {'arabic': 'الْواحِد', 'bangla': 'আল-ওয়াহিদ', 'meaning': 'একক'},
    {'arabic': 'اَلاَحَد', 'bangla': 'আল-আহাদ', 'meaning': 'অদ্বিতীয়'},
    {'arabic': 'الصَّمَد', 'bangla': 'আস-সামাদ', 'meaning': 'অমুখাপেক্ষী'},
    {'arabic': 'الْقَادِر', 'bangla': 'আল-ক্বাদির', 'meaning': 'ক্ষমতাবান'},
    {
      'arabic': 'الْمُقْتَدِر',
      'bangla': 'আল-মুক্তাদির',
      'meaning': 'পরম ক্ষমতাধর'
    },
    {
      'arabic': 'الْمُقَدِّم',
      'bangla': 'আল-মুকাদ্দিম',
      'meaning': 'অগ্রবর্তীকারী'
    },
    {'arabic': 'الْمُؤَخِّر', 'bangla': 'আল-মুআখখির', 'meaning': 'বিলম্বকারী'},
    {'arabic': 'الأوَّل', 'bangla': 'আল-আউয়াল', 'meaning': 'অনাদি'},
    {'arabic': 'الآخِر', 'bangla': 'আল-আখির', 'meaning': 'অনন্ত'},
    {'arabic': 'الظَّاهِر', 'bangla': 'আয-যাহির', 'meaning': 'প্রকাশমান'},
    {'arabic': 'الْبَاطِن', 'bangla': 'আল-বাতিন', 'meaning': 'গোপন'},
    {'arabic': 'الْوَالِي', 'bangla': 'আল-ওয়ালি', 'meaning': 'অভিভাবক'},
    {'arabic': 'الْمُتَعَالِي', 'bangla': 'আল-মুতাআলি', 'meaning': 'সর্বোচ্চ'},
    {'arabic': 'الْبَرّ', 'bangla': 'আল-বাররু', 'meaning': 'কল্যাণকারী'},
    {
      'arabic': 'التَّوَّاب',
      'bangla': 'আত-তাওয়াব',
      'meaning': 'তওবা কবুলকারী'
    },
    {
      'arabic': 'الْمُنْتَقِم',
      'bangla': 'আল-মুনতাকিম',
      'meaning': 'প্রতিশোধগ্রহণকারী'
    },
    {'arabic': 'العَفُوّ', 'bangla': 'আল-আফুও', 'meaning': 'ক্ষমাকারী'},
    {'arabic': 'الرَّؤُوف', 'bangla': 'আর-রাউফ', 'meaning': 'স্নেহশীল'},
    {
      'arabic': 'مَالِكُ الْمُلْك',
      'bangla': 'মালিকুল মুলক',
      'meaning': 'সার্বভৌম অধিপতি'
    },
    {
      'arabic': 'ذُوالْجَلاَلِ وَالإكْرَام',
      'bangla': 'যুল জালালি ওয়াল ইকরাম',
      'meaning': 'মহিমা ও মর্যাদার অধিকারী'
    },
    {
      'arabic': 'الْمُقْسِط',
      'bangla': 'আল-মুক্বসিত',
      'meaning': 'ন্যায়বিচারক'
    },
    {'arabic': 'الْجَامِع', 'bangla': 'আল-জামি', 'meaning': 'একত্রকারী'},
    {'arabic': 'الْغَنِيّ', 'bangla': 'আল-গানিয়্যু', 'meaning': 'অভাবমুক্ত'},
    {'arabic': 'الْمُغْنِي', 'bangla': 'আল-মুগনী', 'meaning': 'অভাবমোচনকারী'},
    {'arabic': 'الْمَانِع', 'bangla': 'আল-মানি', 'meaning': 'প্রতিরোধকারী'},
    {'arabic': 'الضَّار', 'bangla': 'আদ-দার', 'meaning': 'ক্ষতিসাধনকারী'},
    {'arabic': 'النَّافِع', 'bangla': 'আন-নাফি', 'meaning': 'উপকারদানকারী'},
    {'arabic': 'النُّور', 'bangla': 'আন-নূর', 'meaning': 'জ্যোতির্ময়'},
    {'arabic': 'الْهَادِي', 'bangla': 'আল-হাদী', 'meaning': 'পথপ্রদর্শক'},
    {'arabic': 'الْبَدِيع', 'bangla': 'আল-বাদি', 'meaning': 'অতুলনীয় স্রষ্টা'},
    {'arabic': 'البَاقِي', 'bangla': 'আল-বাকী', 'meaning': 'চিরস্থায়ী'},
    {'arabic': 'الْوَارِث', 'bangla': 'আল-ওয়ারিস', 'meaning': 'উত্তরাধিকারী'},
    {'arabic': 'الرَّشِيد', 'bangla': 'আর-রশীদ', 'meaning': 'সৎপথপ্রদর্শক'},
    {'arabic': 'الصَّبُور', 'bangla': 'আস-সাবুর', 'meaning': 'অসীম ধৈর্যশীল'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, isDark),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _names.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final item = _names[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFE2E8F0),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item['arabic']!,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NotoNaskhArabic',
                            color: isDark
                                ? Colors.amber[200]
                                : const Color(0xFF92620A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['bangla']!,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F2E2A),
                          ),
                        ),
                        Text(
                          item['meaning']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
            'আসমাউল হুসনা',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}
