import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'prayer_times.dart';
import 'nafl_times.dart';
import 'cities_data.dart';
import 'islamic_dates.dart';

class CalendarSection extends StatefulWidget {
  final CityLocation selectedCity;

  const CalendarSection({super.key, required this.selectedCity});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late int selectedMonth;
  late int selectedYear;

  static const List<String> _banglaMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর'
  ];

  static const List<String> _banglaWeekdays = [
    'সোমবার',
    'মঙ্গলবার',
    'বুধবার',
    'বৃহস্পতিবার',
    'শুক্রবার',
    'শনিবার',
    'রবিবার'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = now.month;
    selectedYear = now.year;
  }

  int get _daysInMonth => DateTime(selectedYear, selectedMonth + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderRow(),
        const SizedBox(height: 14),
        ...List.generate(_daysInMonth, (index) {
          final day = index + 1;
          final date = DateTime(selectedYear, selectedMonth, day);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDayCard(date),
          );
        }),
        const SizedBox(height: 16),
        _buildImportantDaysCard(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(widget.selectedCity.nameEnglish,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dropdownBox(
            value: _banglaMonths[selectedMonth - 1],
            items: _banglaMonths,
            onChanged: (v) {
              setState(() => selectedMonth = _banglaMonths.indexOf(v!) + 1);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _dropdownBox(
            value: selectedYear.toString(),
            items: const ['2025', '2026', '2027'],
            onChanged: (v) {
              setState(() => selectedYear = int.parse(v!));
            },
          ),
        ),
      ],
    );
  }

  Widget _dropdownBox({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    final uniqueItems = items.toSet().toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: uniqueItems.contains(value) ? value : null,
          isExpanded: true,
          items: uniqueItems
              .map(
                (v) => DropdownMenuItem<String>(
                  value: v,
                  child: Text(v),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDayCard(DateTime date) {
    final prayerTimes = calculatePrayerTimes(
      widget.selectedCity.lat,
      widget.selectedCity.lng,
      date: date,
    );
    final nafl = calculateNaflTimes(prayerTimes);

    // ---- হিজরি তারিখ রূপান্তর ----
    final hijri = HijriCalendar.fromDate(date);
    final hijriStr = '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} হি.';

    final weekdayName = _banglaWeekdays[date.weekday - 1];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$weekdayName ${date.day} ${_banglaMonths[date.month - 1]}, ${date.year}',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            '🌙 $hijriStr',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.green[700], fontSize: 11),
          ),
          const SizedBox(height: 12),

          // ---- ফরজ নামাজ টেবিল (২ কলাম) ----
          _buildTwoColRow('ফজর', '${prayerTimes.fajr} - ${prayerTimes.sunrise}',
              'যুহর', '${prayerTimes.dhuhr} - ${prayerTimes.asrHanafi}'),
          const Divider(height: 18),
          _buildTwoColRow(
              'আসর (হানাফি)',
              '${prayerTimes.asrHanafi} - ${prayerTimes.maghrib}',
              'আসর (শাফেয়ী)',
              '${prayerTimes.asr} - ${prayerTimes.maghrib}'),
          const Divider(height: 18),
          _buildTwoColRow(
              'মাগরিব',
              '${prayerTimes.maghrib} - ${prayerTimes.isha}',
              'ইশা',
              '${prayerTimes.isha} - ${prayerTimes.fajr}'),

          const SizedBox(height: 14),
          Text('নামাযের নিষিদ্ধ সময়',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 8),
          _buildThreeColRow(
            'সূর্যোদয়কালীন',
            prayerTimes.sunrise,
            'দুপুর',
            prayerTimes.dhuhr,
            'সূর্যাস্তকালীন',
            prayerTimes.maghrib,
          ),

          const SizedBox(height: 14),
          Text('নফল নামায',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
          const SizedBox(height: 8),
          _buildThreeColRow(
            'তাহাজ্জুদ শেষ',
            prayerTimes.fajr,
            'ইশরাক',
            '${nafl.ishraqStart} - ${nafl.ishraqEnd}',
            'চাশত',
            '${nafl.chashtStart} - ${nafl.chashtEnd}',
          ),
        ],
      ),
    );
  }

  Widget _buildTwoColRow(
      String label1, String value1, String label2, String value2) {
    return Row(
      children: [
        Expanded(child: _labelValueCol(label1, value1)),
        Container(width: 1, height: 34, color: Colors.grey[300]),
        Expanded(child: _labelValueCol(label2, value2)),
      ],
    );
  }

  Widget _labelValueCol(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildThreeColRow(
    String l1,
    String v1,
    String l2,
    String v2,
    String l3,
    String v3,
  ) {
    return Row(
      children: [
        Expanded(child: _smallLabelValue(l1, v1)),
        Expanded(child: _smallLabelValue(l2, v2)),
        Expanded(child: _smallLabelValue(l3, v3)),
      ],
    );
  }

  Widget _smallLabelValue(String label, String value) {
    return Column(
      children: [
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        const SizedBox(height: 2),
        Text(value,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildImportantDaysCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('গুরুত্বপূর্ণ দিনসমূহ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          const SizedBox(height: 4),
          const Text(
            '⚠️ চাঁদ দেখার উপর নির্ভরশীল, তাই তারিখ আনুমানিক/সম্ভাব্য',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orange, fontSize: 9),
          ),
          const SizedBox(height: 10),
          ...(selectedYear == 2027 ? islamicEvents2027 : islamicEvents2026)
              .map((event) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(event.nameBangla,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(event.hijriDate,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey[600])),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(event.gregorianDate,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.green[700])),
                            ),
                          ],
                        ),
                        const Divider(height: 14),
                      ],
                    ),
                  )),
        ],
      ),
    );
  }
}
