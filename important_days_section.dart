import 'package:flutter/material.dart';

class ImportantDaysData {
  static const Map<int, List<Map<String, String>>> daysData = {
    2026: [
      {
        'title': 'শবে বরাত',
        'hijri': '১৫ শাবান ১৪৪৭ হিজরি',
        'english': '০২ ফেব্রুয়ারি ২০২৬',
        'color': '2E7D32',
      },
      {
        'title': 'পহেলা রমজান',
        'hijri': 'পহেলা রমজান ১৪৪৭ হিজরি',
        'english': '১৮ ফেব্রুয়ারি ২০২৬ (সম্ভাব্য)',
        'color': '00897B',
      },
      {
        'title': 'শবে কদর (লাইলাতুল কদর)',
        'hijri': '২০-২৯ রমজান ১৪৪৭ হিজরি',
        'english': '০৯-১৮ মার্চ ২০২৬ (সম্ভাব্য)',
        'color': 'B8860B',
      },
      {
        'title': 'ঈদুল ফিতর',
        'hijri': '১ শাওয়াল ১৪৪৭ হিজরি',
        'english': '২০ মার্চ ২০২৬ (সম্ভাব্য)',
        'color': 'F9A825',
      },
      {
        'title': 'আরাফা',
        'hijri': '৯ যিলহজ্জ ১৪৪৭ হিজরি',
        'english': '২৬ মে ২০২৬',
        'color': '6A1B9A',
      },
      {
        'title': 'পবিত্র ঈদুল আযহা',
        'hijri': '১০ জিলহজ ১৪৪৭ হিজরি',
        'english': '২৭ মে ২০২৬',
        'color': 'F9A825',
      },
      {
        'title': 'হজ্জ',
        'hijri': '৮-১৩ যিলহজ্জ ১৪৪৭ হিজরি',
        'english': '২৫-৩০ মে ২০২৬',
        'color': '2E7D32',
      },
      {
        'title': 'পবিত্র আশুরা',
        'hijri': '১০ মহররম ১৪৪৮ হিজরি',
        'english': '২৪ আগস্ট ২০২৬',
        'color': 'B71C1C',
      },
      {
        'title': 'পবিত্র ঈদে মিলাদুন্নবী (সা.)',
        'hijri': '১২ রবিউল আউয়াল ১৪৪৮ হিজরি',
        'english': '৩ সেপ্টেম্বর ২০২৬',
        'color': '2E7D32',
      },
    ],
    2027: [
      {
        'title': 'শবে বরাত',
        'hijri': '১৫ শা\'বান ১৪৪৮ হিজরি',
        'english': '২৩-২৪ জানুয়ারি ২০২৭',
        'color': '2E7D32',
      },
      {
        'title': 'পহেলা রমজান',
        'hijri': 'পহেলা রমজান ১৪৪৮ হিজরি',
        'english': '০৯ ফেব্রুয়ারি ২০২৭ (সম্ভাব্য)',
        'color': '00897B',
      },
      {
        'title': 'লাইলাতুল কদর (শুরু)',
        'hijri': '২০-২৯ রমজান ১৪৪৮ হিজরি',
        'english': '২৮ ফেব্রুয়ারি-০৯ মার্চ ২০২৭ (সম্ভাব্য)',
        'color': 'B8860B',
      },
      {
        'title': 'ঈদুল ফিতর',
        'hijri': 'পহেলা শাওয়াল ১৪৪৮ হিজরি',
        'english': '১০ মার্চ ২০২৭ (সম্ভাব্য)',
        'color': 'F9A825',
      },
      {
        'title': 'আরাফা',
        'hijri': '৯ যিলহজ্জ ১৪৪৮ হিজরি',
        'english': '১৬ মে ২০২৭',
        'color': '6A1B9A',
      },
      {
        'title': 'পবিত্র ঈদুল আযহা',
        'hijri': '১০ যিলহজ্জ ১৪৪৮ হিজরি',
        'english': '১৭ মে ২০২৭',
        'color': 'F9A825',
      },
      {
        'title': 'হজ্জ',
        'hijri': '৮-১৩ যিলহজ্জ ১৪৪৮ হিজরি',
        'english': '১৫-২০ মে ২০২৭',
        'color': '2E7D32',
      },
      {
        'title': 'পবিত্র আশুরা',
        'hijri': '১০ মহররম ১৪৪৯ হিজরি',
        'english': '১৬ জুন ২০২৭',
        'color': 'B71C1C',
      },
    ],
  };
}

class ItalyMonthlyHolidays {
  static const Map<int, List<Map<String, dynamic>>> monthsByYear = {
    2026: [
      {
        'month': 'জানুয়ারি',
        'holidays': ['১ - নববর্ষ (Capodanno)', '৬ - এপিফানি (Epifania)'],
      },
      {'month': 'ফেব্রুয়ারি', 'holidays': <String>[]},
      {'month': 'মার্চ', 'holidays': <String>[]},
      {
        'month': 'এপ্রিল',
        'holidays': [
          '৫ - ইস্টার সানডে (Pasqua)',
          '৬ - ইস্টার মানডে (Pasquetta)',
          '২৫ - মুক্তি দিবস (Liberazione)',
        ],
      },
      {
        'month': 'মে',
        'holidays': ['১ - শ্রমিক দিবস (Festa del Lavoro)'],
      },
      {
        'month': 'জুন',
        'holidays': ['২ - প্রজাতন্ত্র দিবস (Festa della Repubblica)'],
      },
      {'month': 'জুলাই', 'holidays': <String>[]},
      {
        'month': 'আগস্ট',
        'holidays': ['১৫ - ফেরাগোস্তো (Ferragosto)'],
      },
      {'month': 'সেপ্টেম্বর', 'holidays': <String>[]},
      {'month': 'অক্টোবর', 'holidays': <String>[]},
      {
        'month': 'নভেম্বর',
        'holidays': ['১ - অল সেন্টস ডে (Tutti i Santi)'],
      },
      {
        'month': 'ডিসেম্বর',
        'holidays': [
          '৮ - ইমাকুলাতা কনসেপশন (Immacolata)',
          '২৫ - বড়দিন (Natale)',
          '২৬ - সান্তো স্তেফানো (S. Stefano)',
        ],
      },
    ],
    2027: [
      {
        'month': 'জানুয়ারি',
        'holidays': ['১ - নববর্ষ (Capodanno)', '৬ - এপিফানি (Epifania)'],
      },
      {'month': 'ফেব্রুয়ারি', 'holidays': <String>[]},
      {
        'month': 'মার্চ',
        'holidays': [
          '২৮ - ইস্টার সানডে (Pasqua)',
          '২৯ - ইস্টার মানডে (Pasquetta)',
        ],
      },
      {
        'month': 'এপ্রিল',
        'holidays': ['২৫ - মুক্তি দিবস (Liberazione)'],
      },
      {
        'month': 'মে',
        'holidays': ['১ - শ্রমিক দিবস (Festa del Lavoro)'],
      },
      {
        'month': 'জুন',
        'holidays': ['২ - প্রজাতন্ত্র দিবস (Festa della Repubblica)'],
      },
      {'month': 'জুলাই', 'holidays': <String>[]},
      {
        'month': 'আগস্ট',
        'holidays': ['১৫ - ফেরাগোস্তো (Ferragosto)'],
      },
      {'month': 'সেপ্টেম্বর', 'holidays': <String>[]},
      {'month': 'অক্টোবর', 'holidays': <String>[]},
      {
        'month': 'নভেম্বর',
        'holidays': ['১ - অল সেন্টস ডে (Tutti i Santi)'],
      },
      {
        'month': 'ডিসেম্বর',
        'holidays': [
          '৮ - ইমাকুলাতা কনসেপশন (Immacolata)',
          '২৫ - বড়দিন (Natale)',
          '২৬ - সান্তো স্তেফানো (S. Stefano)',
        ],
      },
    ],
  };
}

class ImportantDaysSection extends StatefulWidget {
  final void Function(String tab)? setActiveTab;

  const ImportantDaysSection({super.key, this.setActiveTab});

  @override
  State<ImportantDaysSection> createState() => _ImportantDaysSectionState();
}

class _ImportantDaysSectionState extends State<ImportantDaysSection> {
  int selectedYear = 2026;
  bool showHolidayTab = false;

  static const String _enDigits = '0123456789';
  static const String _bnDigits = '০১২৩৪৫৬৭৮৯';

  String _toBanglaNumber(int number) {
    var s = number.toString();
    for (var i = 0; i < _enDigits.length; i++) {
      s = s.replaceAll(_enDigits[i], _bnDigits[i]);
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final islamicYears = ImportantDaysData.daysData.keys.toList()..sort();
    final days = ImportantDaysData.daysData[selectedYear] ?? [];

    return Container(
      color: const Color(0xFFEFF3F1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _buildHeader(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
            child: showHolidayTab
                ? _buildItalyCalendarGrid()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'গুরুত্বপূর্ণ দিনসমূহ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 18),
                      _buildYearSelector(islamicYears),
                      const SizedBox(height: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFDCE3E0)),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: List.generate(days.length, (index) {
                            final item = days[index];
                            final isEven = index % 2 == 0;
                            final titleColor = Color(
                              int.parse('FF${item['color'] ?? '2E7D32'}',
                                  radix: 16),
                            );
                            return Container(
                              color: isEven
                                  ? Colors.white
                                  : const Color(0xFFDCE6EC),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      item['title'] ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        color: titleColor,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item['hijri'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      item['english'] ?? '',
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static const List<Color> _monthColors = [
    Color(0xFF2E7D32), // জানুয়ারি
    Color(0xFF00897B), // ফেব্রুয়ারি
    Color(0xFF1565C0), // মার্চ
    Color(0xFF6A1B9A), // এপ্রিল
    Color(0xFFF9A825), // মে
    Color(0xFF008C45), // জুন
    Color(0xFFB8860B), // জুলাই
    Color(0xFFCD212A), // আগস্ট
    Color(0xFF546E7A), // সেপ্টেম্বর
    Color(0xFF00838F), // অক্টোবর
    Color(0xFF6D4C41), // নভেম্বর
    Color(0xFFB71C1C), // ডিসেম্বর
  ];

  Widget _buildItalyCalendarGrid() {
    final italyYears = ItalyMonthlyHolidays.monthsByYear.keys.toList()..sort();
    final months = ItalyMonthlyHolidays.monthsByYear[selectedYear] ??
        ItalyMonthlyHolidays.monthsByYear[2026]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF008C45), Color(0xFFCD212A)],
          ).createShader(bounds),
          child: Text(
            '🇮🇹  CALENDARIO ${_toBanglaNumber(selectedYear)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'সরকারি ছুটির দিনসমূহ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildYearSelector(italyYears),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: months.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemBuilder: (context, index) {
            final month = months[index];
            final holidays = month['holidays'] as List<String>;
            final accent = _monthColors[index % _monthColors.length];

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [accent, accent.withValues(alpha: 0.75)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            month['month'] as String,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: holidays.isEmpty
                          ? Center(
                              child: Text(
                                'কোনো ছুটি নেই',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.grey[400],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: holidays
                                  .map(
                                    (h) => Container(
                                      margin: const EdgeInsets.only(bottom: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: accent.withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border(
                                          left: BorderSide(
                                              color: accent, width: 2.5),
                                        ),
                                      ),
                                      child: Text(
                                        h,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: accent,
                                          fontWeight: FontWeight.w600,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF1F4B3F),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 14,
        left: 8,
        right: 16,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              if (widget.setActiveTab != null) {
                widget.setActiveTab!('bibidh');
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showHolidayTab = false),
              child: Text(
                'গুরুত্বপূর্ণ দিনসমূহ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight:
                      showHolidayTab ? FontWeight.w400 : FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(width: 1, height: 18, color: Colors.white24),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => showHolidayTab = true),
              child: Text(
                'ছুটির দিনসমূহ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: showHolidayTab ? Colors.white : Colors.white60,
                  fontSize: 14,
                  fontWeight:
                      showHolidayTab ? FontWeight.bold : FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearSelector(List<int> years) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDCE3E0)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selectedYear,
          isExpanded: true,
          alignment: Alignment.center,
          items: years
              .map(
                (y) => DropdownMenuItem<int>(
                  value: y,
                  child: Center(
                    child: Text(
                      _toBanglaNumber(y),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => selectedYear = v!),
        ),
      ),
    );
  }
}
