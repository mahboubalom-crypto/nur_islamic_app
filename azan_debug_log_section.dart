import 'package:flutter/material.dart';
import 'azan_notification_service.dart';

class AzanDebugLogSection extends StatefulWidget {
  final void Function(String tab)? setActiveTab;

  const AzanDebugLogSection({super.key, this.setActiveTab});

  @override
  State<AzanDebugLogSection> createState() => _AzanDebugLogSectionState();
}

class _AzanDebugLogSectionState extends State<AzanDebugLogSection> {
  String _log = 'লগ দেখতে নিচের বাটনে চাপ দিন...';
  bool _loading = false;

  Future<void> _loadLog() async {
    setState(() => _loading = true);
    final log = await AzanNotificationService.instance.getDebugScheduleLog();
    setState(() {
      _log = log;
      _loading = false;
    });
  }

  Future<void> _sendTest() async {
    setState(() => _loading = true);
    final result =
        await AzanNotificationService.instance.scheduleTestNotification();
    setState(() {
      _log = 'টেস্ট নোটিফিকেশন পাঠানো হলো (৩০ সেকেন্ড পরে আসবে)\nমোড: $result';
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (widget.setActiveTab != null)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => widget.setActiveTab!('bibidh'),
              ),
            const Expanded(
              child: Text(
                'আজান শিডিউল ডিবাগ লগ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _loadLog,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('লগ দেখুন'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _sendTest,
                icon: const Icon(Icons.notifications_active, size: 18),
                label: const Text('টেস্ট পাঠান'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB8860B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _loading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              : SelectableText(
                  _log,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 12,
                    fontFamily: 'monospace',
                    height: 1.5,
                  ),
                ),
        ),
        const SizedBox(height: 12),
        const Text(
          'প্রতিটা লাইনে "exact" মানে সঠিক সময়ে বাজবে। "inexact" থাকলে '
          'ফোনের Settings → Apps → এই অ্যাপ → Alarms & reminders (বা '
          '"Exact alarm") পারমিশন অন করে দাও, তাহলে সব ওয়াক্ত exact মোডে যাবে।',
          style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
