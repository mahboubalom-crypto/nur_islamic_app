import 'package:flutter/material.dart';

class NotificationSection extends StatefulWidget {
  const NotificationSection({super.key});

  @override
  State<NotificationSection> createState() => _NotificationSectionState();
}

class _NotificationSectionState extends State<NotificationSection> {
  int _selectedTab = 0; // 0 = আমার নোটিফিকেশন, 1 = অ্যাপ নোটিফিকেশন

  // TODO: এখনো dummy/static ডেটা — আসল ব্যানার (ছবি, লিংক) backend/API
  // থেকে fetch করার লজিক এখনো যুক্ত করা হয়নি।
  static const List<Map<String, String>> _appNotificationBanners = [
    {
      'title': 'দশের লাঠি একের বোঝা',
      'subtitle':
          'প্রতি মাসে অ্যাপে কিছু দান করুন, নতুবা প্রকল্পগুলো চালিয়ে যাওয়া দুষ্কর',
    },
    {
      'title': 'কিতাব, সুগন্ধি, প্রসাধনী, খানাদানা',
      'subtitle': 'হালাল পণ্যের দোকান থেকে কেনাকাটা করুন',
    },
    {
      'title': 'দৈনিক কুইজ',
      'subtitle': '"দৈনিক কুইজে অংশ নিন, ইলম বাড়ান"',
    },
    {
      'title': 'বিবাহ সেকশন',
      'subtitle': 'আলহামদুলিল্লাহ! ২৬ হাজার+ বায়োডাটা রয়েছে',
    },
    {
      'title': 'চাকরির বিজ্ঞাপন',
      'subtitle':
          'আপনার প্রতিষ্ঠানের জন্য লোক লাগবে? ফ্রিতে মুসলিম বাংলায় বিজ্ঞাপন দিন',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F4),
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(),
          Expanded(
            child: _selectedTab == 0
                ? _buildEmptyMyNotifications()
                : _buildAppNotifications(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF39764E),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 16,
        left: 8,
        right: 8,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: Text(
              'নোটিফিকেশন',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color(0xFF39764E),
      child: Row(
        children: [
          _tabButton('আমার নোটিফিকেশন', 0),
          _tabButton('অ্যাপ নোটিফিকেশন', 1),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? Colors.white : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white60,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMyNotifications() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔔', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'কোনো নোটিফিকেশন নেই',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'নতুন নোটিফিকেশন আসলে এখানে দেখাবে',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppNotifications() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _appNotificationBanners.length,
      itemBuilder: (context, index) {
        final banner = _appNotificationBanners[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _bannerCard(banner),
        );
      },
    );
  }

  Widget _bannerCard(Map<String, String> banner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE1E6E4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner['title']!,
                  style: const TextStyle(
                    color: Color(0xFF0F2E2A),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner['subtitle']!,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: _RibbonClipper(),
              child: Container(
                width: 34,
                height: 34,
                color: Colors.green[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
