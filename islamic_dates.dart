// ==========================================================
// ⚠️ এই তারিখগুলো চাঁদ দেখার উপর নির্ভরশীল, তাই কোনো সূত্র দিয়ে
// গণনা করা সম্ভব না — এগুলো ২০২৬ ও ২০২৭ সালের জন্য স্থিরভাবে বসানো
// (আনুমানিক/সম্ভাব্য), পরের বছর আপডেট করতে হবে।
// ==========================================================

class IslamicEvent {
  final String nameBangla;
  final String hijriDate;
  final String gregorianDate;

  const IslamicEvent({
    required this.nameBangla,
    required this.hijriDate,
    required this.gregorianDate,
  });
}

const List<IslamicEvent> islamicEvents2026 = [
  IslamicEvent(
    nameBangla: 'শবে বরাত',
    hijriDate: "১৫ই শা'বান ১৪৪৭",
    gregorianDate: '০২-০৩ ফেব্রুয়ারি ২০২৬',
  ),
  IslamicEvent(
    nameBangla: 'পহেলা রমজান',
    hijriDate: 'পহেলা রমজান ১৪৪৭',
    gregorianDate: '১৮ ফেব্রুয়ারি ২০২৬ (ভোররাত্র) (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'লাইলাতুল কদর (শুরু)',
    hijriDate: '২০-২৯ রমজান ১৪৪৭',
    gregorianDate: '০৯-১৮ মার্চ ২০২৬ (দিবাগত রাত্র) (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'ঈদুল ফিতর',
    hijriDate: 'পহেলা শাওয়াল ১৪৪৭',
    gregorianDate: '২০ মার্চ ২০২৬ (সকাল) (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'আরাফা',
    hijriDate: '৯ই যিলহজ্জ ১৪৪৭',
    gregorianDate: '২৬ মে ২০২৬',
  ),
  IslamicEvent(
    nameBangla: 'ঈদুল আযহা',
    hijriDate: '১০ই যিলহজ্জ ১৪৪৭',
    gregorianDate: '২৭ মে ২০২৬',
  ),
  IslamicEvent(
    nameBangla: 'হজ্জ',
    hijriDate: '৮-১৩ যিলহজ্জ ১৪৪৭',
    gregorianDate: '২৫-৩০ মে ২০২৬',
  ),
  IslamicEvent(
    nameBangla: 'আশুরা',
    hijriDate: '১০ই মহররম ১৪৪৮',
    gregorianDate: '২৫ জুন ২০২৬',
  ),
];

// ==========================================================
// ২০২৭ সালের গুরুত্বপূর্ণ দিনসমূহ (আনুমানিক/সম্ভাব্য)
// হিজরি ১৪৪৮ সাল অনুযায়ী, ২০২৬-এর তারিখ থেকে হিজরি বছরের
// দৈর্ঘ্য (~৩৫৪ দিন) হিসাব করে অনুমান করা — চাঁদ দেখার পর
// প্রকৃত তারিখ ১-২ দিন এদিক-ওদিক হতে পারে
// ==========================================================
const List<IslamicEvent> islamicEvents2027 = [
  IslamicEvent(
    nameBangla: 'শবে বরাত',
    hijriDate: "১৫ই শা'বান ১৪৪৮",
    gregorianDate: '২২-২৩ জানুয়ারি ২০২৭ (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'পহেলা রমজান',
    hijriDate: 'পহেলা রমজান ১৪৪৮',
    gregorianDate: '৭ ফেব্রুয়ারি ২০২৭ (ভোররাত্র) (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'লাইলাতুল কদর (শুরু)',
    hijriDate: '২০-২৯ রমজান ১৪৪৮',
    gregorianDate: '২৬ ফেব্রুয়ারি-৭ মার্চ ২০২৭ (দিবাগত রাত্র) (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'ঈদুল ফিতর',
    hijriDate: 'পহেলা শাওয়াল ১৪৪৮',
    gregorianDate: '৯ মার্চ ২০২৭ (সকাল) (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'আরাফা',
    hijriDate: '৯ই যিলহজ্জ ১৪৪৮',
    gregorianDate: '১৫ মে ২০২৭ (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'ঈদুল আযহা',
    hijriDate: '১০ই যিলহজ্জ ১৪৪৮',
    gregorianDate: '১৬ মে ২০২৭ (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'হজ্জ',
    hijriDate: '৮-১৩ যিলহজ্জ ১৪৪৮',
    gregorianDate: '১৪-১৯ মে ২০২৭ (সম্ভাব্য)',
  ),
  IslamicEvent(
    nameBangla: 'আশুরা',
    hijriDate: '১০ই মহররম ১৪৪৯',
    gregorianDate: '১৪ জুন ২০২৭ (সম্ভাব্য)',
  ),
];
