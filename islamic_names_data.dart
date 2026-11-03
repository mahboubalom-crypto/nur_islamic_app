class NameItem {
  final String nameBangla;
  final String nameArabic;
  final String meaningBangla;
  final String gender; // 'boy' or 'girl'

  const NameItem({
    required this.nameBangla,
    required this.nameArabic,
    required this.meaningBangla,
    required this.gender,
  });
}

const List<NameItem> islamicNamesCollection = [
  // ---- ছেলেদের নাম ----
  NameItem(
      nameBangla: 'মুহাম্মদ',
      nameArabic: 'محمد',
      meaningBangla: 'প্রশংসিত ব্যক্তি',
      gender: 'boy'),
  NameItem(
      nameBangla: 'ইব্রাহিম',
      nameArabic: 'إبراهيم',
      meaningBangla: 'জাতির পিতা',
      gender: 'boy'),
  NameItem(
      nameBangla: 'ইউসুফ',
      nameArabic: 'يوسف',
      meaningBangla: 'আল্লাহ বৃদ্ধি করুন',
      gender: 'boy'),
  NameItem(
      nameBangla: 'ইয়াহিয়া',
      nameArabic: 'يحيى',
      meaningBangla: 'জীবিত থাকা',
      gender: 'boy'),
  NameItem(
      nameBangla: 'উমর',
      nameArabic: 'عمر',
      meaningBangla: 'দীর্ঘজীবী',
      gender: 'boy'),
  NameItem(
      nameBangla: 'উসমান',
      nameArabic: 'عثمان',
      meaningBangla: 'সাহাবীর নাম',
      gender: 'boy'),
  NameItem(
      nameBangla: 'আলী',
      nameArabic: 'علي',
      meaningBangla: 'উচ্চ মর্যাদাসম্পন্ন',
      gender: 'boy'),
  NameItem(
      nameBangla: 'হামজা',
      nameArabic: 'حمزة',
      meaningBangla: 'দৃঢ় ও শক্তিশালী',
      gender: 'boy'),
  NameItem(
      nameBangla: 'বিলাল',
      nameArabic: 'بلال',
      meaningBangla: 'সাহাবীর নাম',
      gender: 'boy'),
  NameItem(
      nameBangla: 'জায়েদ',
      nameArabic: 'زيد',
      meaningBangla: 'বৃদ্ধি',
      gender: 'boy'),
  NameItem(
      nameBangla: 'তারিক',
      nameArabic: 'طارق',
      meaningBangla: 'রাতের আগন্তুক',
      gender: 'boy'),
  NameItem(
      nameBangla: 'ফয়সাল',
      nameArabic: 'فيصل',
      meaningBangla: 'ন্যায়বিচারক',
      gender: 'boy'),
  NameItem(
      nameBangla: 'হাসান',
      nameArabic: 'حسن',
      meaningBangla: 'সুন্দর, উত্তম',
      gender: 'boy'),
  NameItem(
      nameBangla: 'হুসাইন',
      nameArabic: 'حسين',
      meaningBangla: 'সুন্দরের ক্ষুদ্র রূপ',
      gender: 'boy'),
  NameItem(
      nameBangla: 'রায়হান',
      nameArabic: 'ريحان',
      meaningBangla: 'জান্নাতের রিজিক',
      gender: 'boy'),
  NameItem(
      nameBangla: 'সালমান',
      nameArabic: 'سلمان',
      meaningBangla: 'নিরাপদ, শান্তিপ্রিয়',
      gender: 'boy'),
  NameItem(
      nameBangla: 'আদনান',
      nameArabic: 'عدنان',
      meaningBangla: 'স্থায়ী বাসিন্দা',
      gender: 'boy'),
  NameItem(
      nameBangla: 'ইমরান',
      nameArabic: 'عمران',
      meaningBangla: 'সমৃদ্ধি',
      gender: 'boy'),
  NameItem(
      nameBangla: 'মুসআব',
      nameArabic: 'مصعب',
      meaningBangla: 'কঠিন কাজে অটল',
      gender: 'boy'),
  NameItem(
      nameBangla: 'আব্দুল্লাহ',
      nameArabic: 'عبد الله',
      meaningBangla: 'আল্লাহর বান্দা',
      gender: 'boy'),

  // ---- মেয়েদের নাম ----
  NameItem(
      nameBangla: 'আয়েশা',
      nameArabic: 'عائشة',
      meaningBangla: 'জীবিত, প্রাণবন্ত',
      gender: 'girl'),
  NameItem(
      nameBangla: 'ফাতিমা',
      nameArabic: 'فاطمة',
      meaningBangla: 'সংযমী',
      gender: 'girl'),
  NameItem(
      nameBangla: 'খাদিজা',
      nameArabic: 'خديجة',
      meaningBangla: 'সম্মানিতা',
      gender: 'girl'),
  NameItem(
      nameBangla: 'জয়নব',
      nameArabic: 'زينب',
      meaningBangla: 'সুগন্ধযুক্ত গাছ',
      gender: 'girl'),
  NameItem(
      nameBangla: 'মরিয়ম',
      nameArabic: 'مريم',
      meaningBangla: 'ইবাদতকারিণী',
      gender: 'girl'),
  NameItem(
      nameBangla: 'সাফিয়া',
      nameArabic: 'صفية',
      meaningBangla: 'পবিত্র, বিশুদ্ধ',
      gender: 'girl'),
  NameItem(
      nameBangla: 'হাফসা',
      nameArabic: 'حفصة',
      meaningBangla: 'তরুণ সিংহী',
      gender: 'girl'),
  NameItem(
      nameBangla: 'রুকাইয়া',
      nameArabic: 'رقية',
      meaningBangla: 'উচ্চ মর্যাদাসম্পন্ন',
      gender: 'girl'),
  NameItem(
      nameBangla: 'সুমাইয়া',
      nameArabic: 'سمية',
      meaningBangla: 'উচ্চ মর্যাদাশীলা',
      gender: 'girl'),
  NameItem(
      nameBangla: 'আসমা',
      nameArabic: 'أسماء',
      meaningBangla: 'সম্মানিতা',
      gender: 'girl'),
  NameItem(
      nameBangla: 'নূর',
      nameArabic: 'نور',
      meaningBangla: 'আলো, জ্যোতি',
      gender: 'girl'),
  NameItem(
      nameBangla: 'সালমা',
      nameArabic: 'سلمى',
      meaningBangla: 'নিরাপদ, শান্তিপ্রিয়া',
      gender: 'girl'),
  NameItem(
      nameBangla: 'ইয়াসমিন',
      nameArabic: 'ياسمين',
      meaningBangla: 'জেসমিন ফুল',
      gender: 'girl'),
  NameItem(
      nameBangla: 'হুমাইরা',
      nameArabic: 'حميراء',
      meaningBangla: 'গোলাপি আভাযুক্তা',
      gender: 'girl'),
  NameItem(
      nameBangla: 'মাইশা',
      nameArabic: 'ميشا',
      meaningBangla: 'সুখী জীবনযাপনকারিণী',
      gender: 'girl'),
  NameItem(
      nameBangla: 'তাহিয়া',
      nameArabic: 'تحية',
      meaningBangla: 'অভিবাদন, সালাম',
      gender: 'girl'),
  NameItem(
      nameBangla: 'জান্নাত',
      nameArabic: 'جنة',
      meaningBangla: 'বেহেশত, উদ্যান',
      gender: 'girl'),
  NameItem(
      nameBangla: 'মাহনূর',
      nameArabic: 'ماه نور',
      meaningBangla: 'চাঁদের আলো',
      gender: 'girl'),
  NameItem(
      nameBangla: 'রাহিমা',
      nameArabic: 'رحيمة',
      meaningBangla: 'দয়ালু, করুণাময়ী',
      gender: 'girl'),
  NameItem(
      nameBangla: 'সাবিহা',
      nameArabic: 'صبيحة',
      meaningBangla: 'সুন্দরী, উজ্জ্বল',
      gender: 'girl'),
];
