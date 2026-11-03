class ItalyHoliday {
  final String titleBangla; // e.g. "নববর্ষ"
  final String titleItalian; // e.g. "Capodanno"
  final String gregorianLabel; // e.g. "১ জানুয়ারি ২০২৬ (বৃহস্পতিবার)"

  const ItalyHoliday({
    required this.titleBangla,
    required this.titleItalian,
    required this.gregorianLabel,
  });
}

/// Italy's official national public holidays grouped by Gregorian year.
/// To add a new year later, just add a new entry like:
/// 2027: [ ItalyHoliday(...), ItalyHoliday(...) ],
final Map<int, List<ItalyHoliday>> italyHolidaysByYear = {
  2026: [
    ItalyHoliday(
      titleBangla: 'নববর্ষ',
      titleItalian: 'Capodanno',
      gregorianLabel: '১ জানুয়ারি ২০২৬ (বৃহস্পতিবার)',
    ),
    ItalyHoliday(
      titleBangla: 'এপিফানি',
      titleItalian: 'Epifania',
      gregorianLabel: '৬ জানুয়ারি ২০২৬ (মঙ্গলবার)',
    ),
    ItalyHoliday(
      titleBangla: 'ইস্টার সানডে',
      titleItalian: 'Pasqua',
      gregorianLabel: '৫ এপ্রিল ২০২৬ (রবিবার)',
    ),
    ItalyHoliday(
      titleBangla: 'ইস্টার মানডে',
      titleItalian: 'Pasquetta (Lunedì dell\'Angelo)',
      gregorianLabel: '৬ এপ্রিল ২০২৬ (সোমবার)',
    ),
    ItalyHoliday(
      titleBangla: 'মুক্তি দিবস',
      titleItalian: 'Festa della Liberazione',
      gregorianLabel: '২৫ এপ্রিল ২০২৬ (শনিবার)',
    ),
    ItalyHoliday(
      titleBangla: 'শ্রমিক দিবস',
      titleItalian: 'Festa dei Lavoratori',
      gregorianLabel: '১ মে ২০২৬ (শুক্রবার)',
    ),
    ItalyHoliday(
      titleBangla: 'প্রজাতন্ত্র দিবস',
      titleItalian: 'Festa della Repubblica',
      gregorianLabel: '২ জুন ২০২৬ (মঙ্গলবার)',
    ),
    ItalyHoliday(
      titleBangla: 'ফেরাগোস্তো (মেরির স্বর্গারোহণ)',
      titleItalian: 'Ferragosto / Assunzione',
      gregorianLabel: '১৫ আগস্ট ২০২৬ (শনিবার)',
    ),
    ItalyHoliday(
      titleBangla: 'অল সেইন্টস ডে',
      titleItalian: 'Ognissanti',
      gregorianLabel: '১ নভেম্বর ২০২৬ (রবিবার)',
    ),
    ItalyHoliday(
      titleBangla: 'ইমাকুলাতা কনসেপশন',
      titleItalian: 'Immacolata Concezione',
      gregorianLabel: '৮ ডিসেম্বর ২০২৬ (মঙ্গলবার)',
    ),
    ItalyHoliday(
      titleBangla: 'বড়দিন',
      titleItalian: 'Natale',
      gregorianLabel: '২৫ ডিসেম্বর ২০২৬ (শুক্রবার)',
    ),
    ItalyHoliday(
      titleBangla: 'সান্তো স্তেফানো',
      titleItalian: 'Santo Stefano',
      gregorianLabel: '২৬ ডিসেম্বর ২০২৬ (শনিবার)',
    ),
  ],
};
