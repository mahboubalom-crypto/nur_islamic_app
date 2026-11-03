import 'package:flutter/material.dart';

class OthersSettingsSection extends StatelessWidget {
  final void Function(String tab)? setActiveTab;

  const OthersSettingsSection({super.key, this.setActiveTab});

  static const String appName = 'Nur Islamic App';
  static const String appVersion = '১.০.০';

  static const List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'থিম (ডার্ক/লাইট)',
      'icon': Icons.dark_mode,
      'color': Color(0xFF546E7A),
      'action': 'theme',
    },
    {
      'title': 'নোটিফিকেশন সেটিংস',
      'icon': Icons.notifications_active,
      'color': Color(0xFF2E7D32),
      'action': 'notification',
    },
    {
      'title': 'আজান শিডিউল ডিবাগ লগ',
      'icon': Icons.bug_report,
      'color': Color(0xFFB8860B),
      'action': 'azan_debug',
    },
    {
      'title': 'আমাদের সম্পর্কে',
      'icon': Icons.info_outline,
      'color': Color(0xFF1565C0),
      'action': 'about',
    },
    {
      'title': 'প্রাইভেসি পলিসি',
      'icon': Icons.privacy_tip_outlined,
      'color': Color(0xFF6A1B9A),
      'action': 'privacy',
    },
    {
      'title': 'শর্তাবলী (Terms & Conditions)',
      'icon': Icons.description_outlined,
      'color': Color(0xFF00897B),
      'action': 'terms',
    },
    {
      'title': 'লাইসেন্স তথ্য',
      'icon': Icons.article_outlined,
      'color': Color(0xFF37474F),
      'action': 'license',
    },
    {
      'title': 'অ্যাপ শেয়ার করুন',
      'icon': Icons.share,
      'color': Color(0xFFF9A825),
      'action': 'share',
    },
    {
      'title': 'রেটিং দিন',
      'icon': Icons.star_rate,
      'color': Color(0xFFF9A825),
      'action': 'rate',
    },
    {
      'title': 'যোগাযোগ করুন',
      'icon': Icons.mail_outline,
      'color': Color(0xFF00897B),
      'action': 'contact',
    },
  ];

  void _handleTap(BuildContext context, String action) {
    switch (action) {
      case 'azan_debug':
        if (setActiveTab != null) setActiveTab!('azan_debug');
        return;
      case 'license':
        showLicensePage(
          context: context,
          applicationName: appName,
          applicationVersion: appVersion,
          applicationIcon: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.mosque, size: 40, color: Color(0xFF236B34)),
          ),
        );
        return;
      case 'about':
        showAboutDialog(
          context: context,
          applicationName: appName,
          applicationVersion: appVersion,
          applicationIcon:
              const Icon(Icons.mosque, size: 40, color: Color(0xFF236B34)),
          children: const [
            SizedBox(height: 12),
            Text(
              'এই অ্যাপটি বাংলাভাষী মুসলিম উম্মাহর দৈনন্দিন ইবাদত '
              '(নামাজের সময়, কিবলা, তাসবিহ, দোয়া, কুরআন, হাদিস ইত্যাদি) '
              'সহজ করার লক্ষ্যে তৈরি করা হয়েছে।',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        );
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('শীঘ্রই যুক্ত করা হবে'),
            duration: Duration(seconds: 1),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: [
        _buildHeader(context, isDark),
        const SizedBox(height: 16),
        _buildAppCard(isDark),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE1E6E4),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: _menuItems
                .map((item) => _buildMenuRow(context, item, isDark))
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '© ২০২৬ $appName — সর্বস্বত্ব সংরক্ষিত',
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ),
        const SizedBox(height: 12),
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
            'সেটিংস ও অন্যান্য',
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

  Widget _buildAppCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1F4B3F), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F4B3F).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.mosque, color: Color(0xFF236B34), size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  appName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'সংস্করণ $appVersion',
                  style: const TextStyle(
                    color: Color(0xFFC8E6C9),
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuRow(
      BuildContext context, Map<String, dynamic> item, bool isDark) {
    final Color iconColor = item['color'] as Color;

    return InkWell(
      onTap: () => _handleTap(context, item['action'] as String),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF2F1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item['icon'] as IconData, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item['title'] as String,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
