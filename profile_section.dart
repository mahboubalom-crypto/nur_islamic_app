import 'package:flutter/material.dart';
import 'registration_screen.dart';

class ProfileSection extends StatefulWidget {
  final void Function(String tab) setActiveTab;

  const ProfileSection({super.key, required this.setActiveTab});

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  // নিবন্ধনে সেভ করা তথ্য (RegistrationStore থেকে, শুধু এই ফোনে থাকে)
  String _name = '';
  String _phone = '';
  String _email = '';
  bool _loaded = false;

  bool get _isRegistered => _name.isNotEmpty;

  // সমস্ত মেনু আইটেম একসাথে এখানে দেওয়া হলো
  static const List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'বুকমার্ক',
      'emoji': '🔖',
      'action': null,
    },
    {
      'title': 'মাসাইল জিজ্ঞাসা',
      'emoji': '❓',
      'action': null,
    },
    {
      'title': 'আমার প্রশ্ন',
      'emoji': '💬',
      'action': null,
    },
    {
      'title': 'বিনিয়োগের ইতিহাস',
      'emoji': '🤝',
      'action': null,
    },
    {
      'title': 'আমার পণ্য',
      'emoji': '🛍️',
      'action': null,
    },
    {
      'title': 'ডাউনলোডকৃত কিতাব',
      'emoji': '📚',
      'action': null,
    },
    {
      'title': 'নামাযের সেটিংস',
      'emoji': '⚙️',
      'action': 'settings',
    },
    {
      'title': 'ফিডব্যাক',
      'emoji': '⭐',
      'action': null,
    },
    {
      'title': 'লগ আউট',
      'emoji': '🚪',
      'action': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await RegistrationStore.load();
      if (!mounted) return;
      setState(() {
        _name = data['name'] ?? '';
        _phone = data['phone'] ?? '';
        _email = data['email'] ?? '';
        _loaded = true;
      });
    } catch (_) {
      if (mounted) setState(() => _loaded = true);
    }
  }

  // স্কিপ করা ব্যবহারকারী পরে এখান থেকে নিবন্ধন করতে পারবেন।
  void _openRegistration() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (routeContext) => RegistrationScreen(
              isDarkTheme: false,
              onFinished: () => Navigator.of(routeContext).pop(),
            ),
          ),
        )
        .then((_) => _loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 4),
      children: [
        _buildProfileCard(),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE1E6E4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children:
                _menuItems.map((item) => _buildMenuRow(context, item)).toList(),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildProfileCard() {
    final registered = _isRegistered;
    final title = !_loaded ? '' : (registered ? _name : 'অতিথি');

    return GestureDetector(
      onTap: (_loaded && !registered) ? _openRegistration : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
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
              padding: const EdgeInsets.all(2.5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (_loaded && registered) ...[
                    const Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFFA5D6A7), size: 14),
                        SizedBox(width: 4),
                        Text(
                          'রেজিস্ট্রেশন সম্পন্ন',
                          style: TextStyle(
                            color: Color(0xFFC8E6C9),
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (_phone.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        _phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11.5),
                      ),
                    ],
                    if (_email.isNotEmpty)
                      Text(
                        _email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 11.5),
                      ),
                  ] else if (_loaded)
                    const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Color(0xFFFFE082), size: 14),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'নিবন্ধন করা হয়নি — ট্যাপ করে নিবন্ধন করুন',
                            style: TextStyle(
                              color: Color(0xFFFFF3C4),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (_loaded && !registered)
              const Icon(Icons.chevron_right, color: Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuRow(BuildContext context, Map<String, dynamic> item) {
    final bool isLogout = item['title'] == 'লগ আউট';

    return InkWell(
      onTap: () {
        final action = item['action'] as String?;
        if (action != null) {
          widget.setActiveTab(action);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isLogout ? 'লগ আউট ফিচারটি শীঘ্রই আসছে' : 'শীঘ্রই আসছে',
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEFF2F1), width: 1),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 38,
              height: 38,
              child: Center(
                child: Text(
                  item['emoji'] as String,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item['title'] as String,
                style: TextStyle(
                  color: isLogout ? Colors.red : const Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
