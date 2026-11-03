import 'package:flutter/material.dart';
import 'timer_section.dart';
import 'alarm_list_section.dart';
import 'world_clock_section.dart';
import 'stopwatch_section.dart';

class AlarmTimerSection extends StatefulWidget {
  const AlarmTimerSection({super.key});

  @override
  State<AlarmTimerSection> createState() => _AlarmTimerSectionState();
}

class _AlarmTimerSectionState extends State<AlarmTimerSection> {
  String activeTab = 'alarm';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.78,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: _buildActiveContent(),
            ),
          ),
          _buildBottomTabBar(),
        ],
      ),
    );
  }

  Widget _buildActiveContent() {
    switch (activeTab) {
      case 'world_clock':
        return const WorldClockSection();
      case 'stopwatch':
        return const StopwatchSection();
      case 'timer':
        return const TimerSection();
      case 'alarm':
      default:
        return const AlarmListSection();
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF064E3B), Color(0xFF0F2E2A)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.amber, size: 22),
          const SizedBox(width: 8),
          const Expanded(
            child: Text('Islamic Alarm & Clock',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings — coming soon'),
                ),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.white70, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomTabItem('Alarm', 'alarm', Icons.alarm),
          _bottomTabItem('World clock', 'world_clock', Icons.public),
          _bottomTabItem('Stopwatch', 'stopwatch', Icons.timer_outlined),
          _bottomTabItem('Timer', 'timer', Icons.hourglass_bottom),
        ],
      ),
    );
  }

  Widget _bottomTabItem(String label, String value, IconData icon) {
    final isActive = activeTab == value;
    return InkWell(
      onTap: () => setState(() => activeTab = value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 22, color: isActive ? Colors.amber : Colors.grey[500]),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.amber : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
