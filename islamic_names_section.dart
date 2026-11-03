import 'package:flutter/material.dart';

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
      meaningBangla: 'অল্পবয়স্ক সাপ / সাহাবীর নাম',
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
      meaningBangla: 'জলসিক্ত / সাহাবীর নাম',
      gender: 'boy'),
  NameItem(
      nameBangla: 'জায়েদ',
      nameArabic: 'زيد',
      meaningBangla: 'বৃদ্ধি',
      gender: 'boy'),
  NameItem(
      nameBangla: 'তারিক',
      nameArabic: 'طارق',
      meaningBangla: 'রাতের আগন্তুক / সকালের তারা',
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
      nameBangla: 'জুনায়েদ',
      nameArabic: 'جنيد',
      meaningBangla: 'যোদ্ধা',
      gender: 'boy'),
  NameItem(
      nameBangla: 'রায়হান',
      nameArabic: 'ريحان',
      meaningBangla: 'সুগন্ধি গাছ, জান্নাতের রিজিক',
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

  // ---- মেয়েদের নাম ----
  NameItem(
      nameBangla: 'আয়েশা',
      nameArabic: 'عائشة',
      meaningBangla: 'জীবিত, প্রাণবন্ত',
      gender: 'girl'),
  NameItem(
      nameBangla: 'ফাতিমা',
      nameArabic: 'فاطمة',
      meaningBangla: 'স্তন্যদানকারিণী / সংযমী',
      gender: 'girl'),
  NameItem(
      nameBangla: 'খাদিজা',
      nameArabic: 'خديجة',
      meaningBangla: 'অকালপ্রসূত সন্তান / সম্মানিতা',
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
      meaningBangla: 'পবিত্র, বিশুদ্ধ বান্ধবী',
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
      meaningBangla: 'সম্মানিতা, মর্যাদাবান',
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
      meaningBangla: 'সুন্দরী, উজ্জ্বল মুখাবয়ব',
      gender: 'girl'),
];

class IslamicNamesSection extends StatefulWidget {
  final bool isDarkTheme;

  const IslamicNamesSection({
    super.key,
    this.isDarkTheme = false,
  });

  @override
  State<IslamicNamesSection> createState() => _IslamicNamesSectionState();
}

class _IslamicNamesSectionState extends State<IslamicNamesSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<NameItem> _filteredNames(String gender) {
    return islamicNamesCollection.where((n) {
      final matchesGender = n.gender == gender;
      final matchesSearch = searchQuery.isEmpty ||
          n.nameBangla.contains(searchQuery) ||
          n.meaningBangla.contains(searchQuery);
      return matchesGender && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = widget.isDarkTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF064E3B), Color(0xFF0F2E2A)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.badge_outlined, color: Colors.amber, size: 20),
                  SizedBox(width: 8),
                  Text('ইসলামিক নাম',
                      style: TextStyle(
                          fontFamily: 'NotoSansBengali',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                style: const TextStyle(
                    fontFamily: 'NotoSansBengali',
                    color: Colors.white,
                    fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'নাম খুঁজুন...',
                  hintStyle: const TextStyle(
                      fontFamily: 'NotoSansBengali',
                      color: Colors.white38,
                      fontSize: 12),
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white54, size: 18),
                  filled: true,
                  fillColor: Colors.black26,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: dark ? Colors.grey[900] : const Color(0xFFF0F2F1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Colors.green[600],
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: dark ? Colors.grey[400] : Colors.grey[700],
            labelStyle: const TextStyle(
                fontFamily: 'NotoSansBengali', fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'ছেলেদের নাম'),
              Tab(text: 'মেয়েদের নাম'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildNameList(_filteredNames('boy'), dark),
              _buildNameList(_filteredNames('girl'), dark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNameList(List<NameItem> names, bool dark) {
    if (names.isEmpty) {
      return Center(
        child: Text('কোনো নাম পাওয়া যায়নি',
            style: TextStyle(
                fontFamily: 'NotoSansBengali',
                color: dark ? Colors.grey[400] : Colors.grey[600])),
      );
    }
    return ListView.separated(
      itemCount: names.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final n = names[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: dark ? Colors.grey[900]?.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: dark ? Colors.grey[700]! : const Color(0xFFE1E6E4)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(n.nameBangla,
                            style: TextStyle(
                                fontFamily: 'NotoSansBengali',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: dark
                                    ? Colors.white
                                    : const Color(0xFF0F2E2A))),
                        const SizedBox(width: 8),
                        Text(n.nameArabic,
                            style: TextStyle(
                                fontFamily: 'NotoNaskhArabic',
                                fontSize: 14,
                                color: dark
                                    ? const Color(0xFFFDE68A)
                                    : const Color(0xFF92620A))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('অর্থ: ${n.meaningBangla}',
                        style: TextStyle(
                            fontFamily: 'NotoSansBengali',
                            fontSize: 12,
                            color: dark ? Colors.grey[300] : Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
