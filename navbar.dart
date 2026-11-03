import 'package:flutter/material.dart';
import 'cities_data.dart';
import 'location_picker.dart';

String _englishDateLabel(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return '${months[date.month - 1]}-${date.day}';
}

class NavbarHeader extends StatefulWidget implements PreferredSizeWidget {
  final CityLocation selectedCity;
  final void Function(CityLocation city) setSelectedCity;
  final void Function(String tab) setActiveTab;

  const NavbarHeader({
    super.key,
    required this.selectedCity,
    required this.setSelectedCity,
    required this.setActiveTab,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  State<NavbarHeader> createState() => _NavbarHeaderState();
}

class _NavbarHeaderState extends State<NavbarHeader> {
  DateTime selectedDate = DateTime.now();

  Future<void> _openDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      locale: const Locale('en', 'US'),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      backgroundColor:
          isDark ? const Color(0xFF020617) : const Color(0xFFF2F5F4),
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 12,
      title: Row(
        children: [
          // Profile
          InkWell(
            onTap: () => widget.setActiveTab('profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? Colors.green[900] : Colors.green[50],
                border: Border.all(
                  color: Colors.green.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.person,
                color: isDark ? Colors.green[200] : Colors.green[800],
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Date
          Expanded(
            child: InkWell(
              onTap: () => _openDatePicker(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _englishDateLabel(selectedDate),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Location
          Expanded(
            child: InkWell(
              onTap: () {
                showLocationPicker(
                  context: context,
                  onCitySelected: (city) {
                    widget.setSelectedCity(city);
                  },
                  onGpsLocation: (lat, lng) {
                    final cities = [
                      ...bangladeshCities,
                      ...worldCities,
                    ];

                    CityLocation? nearest;
                    double minDistance = double.infinity;

                    for (final city in cities) {
                      final distance =
                          (city.lat - lat).abs() + (city.lng - lng).abs();

                      if (distance < minDistance) {
                        minDistance = distance;
                        nearest = city;
                      }
                    }

                    if (nearest != null) {
                      widget.setSelectedCity(nearest);
                    }
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Colors.green[700],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.selectedCity.nameEnglish,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Notification
          InkWell(
            onTap: () => widget.setActiveTab('notification'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    size: 18,
                    color: Colors.green[700],
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryBottomNav extends StatelessWidget {
  final String activeTab;
  final void Function(String tab) setActiveTab;

  const PrimaryBottomNav({
    super.key,
    required this.activeTab,
    required this.setActiveTab,
  });

  static const List<Map<String, dynamic>> _tabs = [
    {'id': 'ilm', 'label': 'ইলম', 'icon': Icons.menu_book},
    {'id': 'amal', 'label': 'আমল', 'icon': Icons.check_box_outlined},
    {'id': 'seba', 'label': 'সেবা', 'icon': Icons.shopping_bag_outlined},
    {'id': 'bibidh', 'label': 'বিবিধ', 'icon': Icons.grid_view},
  ];

  bool _isTabActive(String id) {
    if (activeTab == id) return true;

    if (id == 'ilm') {
      return ['home', 'quran', 'hadith'].contains(activeTab);
    }

    if (id == 'amal') {
      return ['prayer', 'dua', 'tasbih'].contains(activeTab);
    }

    if (id == 'bibidh') {
      return ['qibla', 'calendar', 'settings', 'profile'].contains(activeTab);
    }

    if (id == 'seba') {
      return ['seba', 'alarm'].contains(activeTab);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _tabs.map((tab) {
          final id = tab['id'] as String;
          final active = _isTabActive(id);

          return InkWell(
            onTap: () => setActiveTab(id),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: active
                    ? (isDark ? Colors.green[950] : Colors.green[50])
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    tab['icon'] as IconData,
                    size: 20,
                    color: active ? Colors.green[700] : Colors.grey,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tab['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: active ? FontWeight.bold : FontWeight.normal,
                      color: active ? Colors.green[800] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
