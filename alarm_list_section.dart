import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'alarm_notification_service.dart';

class AlarmSoundOption {
  final String id;
  final String label;
  final String assetPath;

  const AlarmSoundOption({
    required this.id,
    required this.label,
    required this.assetPath,
  });
}

const List<AlarmSoundOption> alarmSoundOptions = [
  AlarmSoundOption(
    id: 'default',
    label: 'Default alarm sound',
    assetPath: 'audio/adhan.mp3',
  ),
  AlarmSoundOption(
    id: 'tone1',
    label: 'Tone 1',
    assetPath: 'audio/alarm_tone1.mp3',
  ),
  AlarmSoundOption(
    id: 'tone2',
    label: 'Tone 2',
    assetPath: 'audio/alarm_tone2.mp3',
  ),
  AlarmSoundOption(
    id: 'rooster',
    label: 'Rooster crow',
    assetPath: 'audio/alarm_rooster.mp3',
  ),
  AlarmSoundOption(
    id: 'bird',
    label: 'Bird chirp',
    assetPath: 'audio/alarm_bird.mp3',
  ),
  AlarmSoundOption(
    id: 'duck',
    label: 'Duck quack',
    assetPath: 'audio/alarm_duck.mp3',
  ),
  AlarmSoundOption(
    id: 'cuckoo',
    label: 'Cuckoo bird',
    assetPath: 'audio/alarm_cuckoo.mp3',
  ),
  AlarmSoundOption(
    id: 'ar_rahman_1',
    label: 'সূরা আর-রাহমান (আয়াত ১)',
    assetPath:
        'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1786.mp3',
  ),
  AlarmSoundOption(
    id: 'ar_rahman_2',
    label: 'সূরা আর-রাহমান (আয়াত ২)',
    assetPath:
        'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1787.mp3',
  ),
  AlarmSoundOption(
    id: 'ar_rahman_3',
    label: 'সূরা আর-রাহমান (আয়াত ৩)',
    assetPath:
        'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1788.mp3',
  ),
];

class AlarmItem {
  final String id;
  final String title;
  final String time;
  final bool enabled;
  final String repeatMode;
  final List<int> customDays;
  final String soundId;
  final bool vibrate;

  const AlarmItem({
    required this.id,
    required this.title,
    required this.time,
    required this.enabled,
    this.repeatMode = 'once',
    this.customDays = const [],
    this.soundId = 'default',
    this.vibrate = true,
  });

  AlarmItem copyWith({
    String? title,
    String? time,
    bool? enabled,
    String? repeatMode,
    List<int>? customDays,
    String? soundId,
    bool? vibrate,
  }) {
    return AlarmItem(
      id: id,
      title: title ?? this.title,
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
      repeatMode: repeatMode ?? this.repeatMode,
      customDays: customDays ?? this.customDays,
      soundId: soundId ?? this.soundId,
      vibrate: vibrate ?? this.vibrate,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'time': time,
        'enabled': enabled,
        'repeatMode': repeatMode,
        'customDays': customDays,
        'soundId': soundId,
        'vibrate': vibrate,
      };

  factory AlarmItem.fromJson(Map<String, dynamic> json) => AlarmItem(
        id: json['id'],
        title: json['title'],
        time: json['time'],
        enabled: json['enabled'],
        repeatMode: json['repeatMode'] ?? 'once',
        customDays: (json['customDays'] as List?)?.cast<int>() ?? [],
        soundId: json['soundId'] ?? 'default',
        vibrate: json['vibrate'] ?? true,
      );

  static const List<String> _dayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  String get repeatLabel {
    switch (repeatMode) {
      case 'weekdays':
        return 'Mon - Fri';
      case 'custom':
        if (customDays.isEmpty) return 'Ring once';
        return customDays.map((d) => _dayNames[d - 1]).join(' ');
      case 'once':
      default:
        return 'Ring once';
    }
  }
}

class AlarmListSection extends StatefulWidget {
  const AlarmListSection({super.key});

  @override
  State<AlarmListSection> createState() => _AlarmListSectionState();
}

class _AlarmListSectionState extends State<AlarmListSection> {
  List<AlarmItem> alarms = [];

  String currentTimeStr = '';
  Timer? _clockTimer;
  String? _lastTriggeredMinute;

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    AudioCache.instance = AudioCache(prefix: '');
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _startClock();
    _setup();
    AlarmNotificationService.instance.lastTappedAlarmId
        .addListener(_onNotificationTapped);
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _audioPlayer.dispose();
    AlarmNotificationService.instance.lastTappedAlarmId
        .removeListener(_onNotificationTapped);
    super.dispose();
  }

  Future<void> _setup() async {
    await AlarmNotificationService.instance.init();
    await _loadAlarms();
    for (final a in alarms.where((a) => a.enabled)) {
      await _scheduleAlarmNotification(a);
    }
    await _checkPendingAlarmFromNotification();
  }

  Future<void> _checkPendingAlarmFromNotification() async {
    final id = await AlarmNotificationService.instance.consumePendingAlarmId();
    _handleTappedAlarmId(id);
  }

  void _onNotificationTapped() {
    final id = AlarmNotificationService.instance.lastTappedAlarmId.value;
    if (id == null) return;
    AlarmNotificationService.instance.lastTappedAlarmId.value = null;
    _handleTappedAlarmId(id);
  }

  void _handleTappedAlarmId(String? id) {
    if (id == null) return;
    AlarmItem? match;
    for (final a in alarms) {
      if (a.id == id) {
        match = a;
        break;
      }
    }
    if (match == null) return;

    _presentRinging(match);
    _playSound(match.soundId);

    if (match.repeatMode == 'once') {
      final matchedId = match.id;
      setState(() {
        alarms = alarms
            .map((a) => a.id == matchedId ? a.copyWith(enabled: false) : a)
            .toList();
      });
      _saveAlarms();
    }
  }

  Future<void> _scheduleAlarmNotification(AlarmItem alarm) async {
    await AlarmNotificationService.instance.scheduleAlarm(
      alarmId: alarm.id,
      title: alarm.title == 'Alarm' ? alarm.repeatLabel : alarm.title,
      hour: int.tryParse(alarm.time.split(':')[0]) ?? 0,
      minute: int.tryParse(alarm.time.split(':')[1]) ?? 0,
      repeatMode: alarm.repeatMode,
      customDays: alarm.customDays,
      soundId: alarm.soundId,
    );
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('nur_alarms_list');
    if (saved != null) {
      final decoded = jsonDecode(saved) as List;
      alarms = decoded.map((e) => AlarmItem.fromJson(e)).toList();
      if (mounted) setState(() {});
    }
  }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'nur_alarms_list',
      jsonEncode(alarms.map((a) => a.toJson()).toList()),
    );
  }

  void _startClock() {
    _checkClock();
    _clockTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _checkClock());
  }

  void _checkClock() {
    final now = DateTime.now();
    final hrs = now.hour.toString().padLeft(2, '0');
    final mins = now.minute.toString().padLeft(2, '0');
    final timeString = '$hrs:$mins';
    final weekday = now.weekday;

    if (mounted) setState(() => currentTimeStr = timeString);

    if (_lastTriggeredMinute != timeString) {
      final matched = alarms.where((a) {
        if (!a.enabled || a.time != timeString) return false;
        if (a.repeatMode == 'weekdays') return weekday >= 1 && weekday <= 5;
        if (a.repeatMode == 'custom') return a.customDays.contains(weekday);
        return true;
      });

      if (matched.isNotEmpty) {
        _lastTriggeredMinute = timeString;
        final triggered = matched.first;
        _presentRinging(triggered);
        _playSound(triggered.soundId);

        if (triggered.repeatMode == 'once') {
          setState(() {
            alarms = alarms
                .map((a) =>
                    a.id == triggered.id ? a.copyWith(enabled: false) : a)
                .toList();
          });
          _saveAlarms();
        }
      }
    }
  }

  Future<void> _playSound(String soundId) async {
    final sound = alarmSoundOptions.firstWhere(
      (s) => s.id == soundId,
      orElse: () => alarmSoundOptions.first,
    );
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setVolume(1.0);

      if (sound.assetPath.startsWith('http')) {
        await _audioPlayer.play(UrlSource(sound.assetPath));
      } else {
        await _audioPlayer.play(AssetSource(sound.assetPath));
      }
    } catch (e) {
      debugPrint('Failed to play alarm sound: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Alarm sound error: $e')),
        );
      }
    }
  }

  Future<void> _stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Failed to stop alarm sound: $e');
    }
  }

  void _presentRinging(AlarmItem alarm) {
    if (!mounted) return;
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, _, __) {
        return _RingingScreen(
          alarm: alarm,
          onStop: () async {
            await _stopSound();
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  void _toggleAlarmEnabled(String id) {
    setState(() {
      alarms = alarms
          .map((a) => a.id == id ? a.copyWith(enabled: !a.enabled) : a)
          .toList();
    });
    _saveAlarms();
    final alarm = alarms.firstWhere((a) => a.id == id);
    if (alarm.enabled) {
      _scheduleAlarmNotification(alarm);
    } else {
      AlarmNotificationService.instance.cancelAlarm(id);
    }
  }

  void _deleteAlarm(String id) {
    AlarmNotificationService.instance.cancelAlarm(id);
    setState(() {
      alarms = alarms.where((a) => a.id != id).toList();
    });
    _saveAlarms();
  }

  Future<void> _openAlarmSheet({AlarmItem? existing}) async {
    final result = await showModalBottomSheet<AlarmItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NewAlarmSheet(existing: existing),
    );

    if (result != null) {
      setState(() {
        if (existing != null) {
          alarms = alarms.map((a) => a.id == existing.id ? result : a).toList();
        } else {
          alarms = [...alarms, result];
        }
      });
      _saveAlarms();
      if (result.enabled) {
        await _scheduleAlarmNotification(result);
      } else {
        await AlarmNotificationService.instance.cancelAlarm(result.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Alarm',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_nextAlarmSummary(),
                style: TextStyle(color: Colors.grey[400], fontSize: 14)),
            const SizedBox(height: 20),
            if (alarms.isEmpty) _buildEmptyState(),
            ...alarms.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildAlarmCard(a),
                )),
            const SizedBox(height: 80),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Center(
            child: InkWell(
              onTap: () => _openAlarmSheet(),
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _nextAlarmSummary() {
    final enabledAlarms = alarms.where((a) => a.enabled).toList();
    if (enabledAlarms.isEmpty) return 'No alarms set';

    DateTime? earliest;

    for (final alarm in enabledAlarms) {
      final parts = alarm.time.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final now = DateTime.now();

      if (alarm.repeatMode == 'weekdays') {
        for (int i = 0; i < 8; i++) {
          final candidate = DateTime(now.year, now.month, now.day, hour, minute)
              .add(Duration(days: i));
          if (candidate.isAfter(now) &&
              candidate.weekday >= 1 &&
              candidate.weekday <= 5) {
            if (earliest == null || candidate.isBefore(earliest)) {
              earliest = candidate;
            }
            break;
          }
        }
      } else if (alarm.repeatMode == 'custom' && alarm.customDays.isNotEmpty) {
        for (int i = 0; i < 8; i++) {
          final candidate = DateTime(now.year, now.month, now.day, hour, minute)
              .add(Duration(days: i));
          if (candidate.isAfter(now) &&
              alarm.customDays.contains(candidate.weekday)) {
            if (earliest == null || candidate.isBefore(earliest)) {
              earliest = candidate;
            }
            break;
          }
        }
      } else {
        var candidate = DateTime(now.year, now.month, now.day, hour, minute);
        if (candidate.isBefore(now)) {
          candidate = candidate.add(const Duration(days: 1));
        }
        if (earliest == null || candidate.isBefore(earliest)) {
          earliest = candidate;
        }
      }
    }

    if (earliest == null) return 'No alarms set';

    final diff = earliest.difference(DateTime.now());
    if (diff.inDays >= 1) {
      return 'Next alarm in ${diff.inDays} day${diff.inDays > 1 ? 's' : ''}';
    }
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    if (hours > 0) {
      return 'Next alarm in $hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes != 1 ? 's' : ''}';
    }
    return 'Next alarm in $minutes minute${minutes != 1 ? 's' : ''}';
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.alarm_off, size: 44, color: Colors.grey[600]),
            const SizedBox(height: 10),
            Text('No alarms',
                style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlarmCard(AlarmItem alarm) {
    return Dismissible(
      key: ValueKey(alarm.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[700],
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteAlarm(alarm.id),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openAlarmSheet(existing: alarm),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alarm.time,
                        style: TextStyle(
                            color:
                                alarm.enabled ? Colors.white : Colors.grey[600],
                            fontSize: 32,
                            fontWeight: FontWeight.w300)),
                    const SizedBox(height: 4),
                    Text(
                      alarm.title == 'Alarm' ? alarm.repeatLabel : alarm.title,
                      style: TextStyle(
                          color: alarm.enabled
                              ? Colors.grey[300]
                              : Colors.grey[600],
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              Switch(
                value: alarm.enabled,
                activeColor: Colors.blueAccent,
                onChanged: (_) => _toggleAlarmEnabled(alarm.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// রিংগিং স্ক্রিন
// ==========================================================
class _RingingScreen extends StatelessWidget {
  final AlarmItem alarm;
  final VoidCallback onStop;

  const _RingingScreen({required this.alarm, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.6,
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                          color: Colors.amber, shape: BoxShape.circle),
                      child: const Icon(Icons.alarm,
                          color: Colors.black, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text(alarm.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(alarm.time,
                        style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 32,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onStop,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Stop alarm',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// নতুন / এডিট অ্যালার্ম শিট
// ==========================================================
class _NewAlarmSheet extends StatefulWidget {
  final AlarmItem? existing;

  const _NewAlarmSheet({this.existing});

  @override
  State<_NewAlarmSheet> createState() => _NewAlarmSheetState();
}

class _NewAlarmSheetState extends State<_NewAlarmSheet> {
  late DateTime _pickedTime;
  late String _repeatMode;
  late Set<int> _customDays;
  late TextEditingController _nameController;
  late String _soundId;
  late bool _vibrate;

  final AudioPlayer _previewPlayer = AudioPlayer();

  static const List<String> _dayLabels = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    super.initState();
    AudioCache.instance = AudioCache(prefix: '');
    final existing = widget.existing;
    if (existing != null) {
      final parts = existing.time.split(':');
      final now = DateTime.now();
      _pickedTime = DateTime(now.year, now.month, now.day, int.parse(parts[0]),
          int.parse(parts[1]));
      _repeatMode = existing.repeatMode;
      _customDays = existing.customDays.toSet();
      _nameController = TextEditingController(
          text: existing.title == 'Alarm' ? '' : existing.title);
      _soundId = existing.soundId;
      _vibrate = existing.vibrate;
    } else {
      _pickedTime = DateTime.now();
      _repeatMode = 'once';
      _customDays = {};
      _nameController = TextEditingController();
      _soundId = 'default';
      _vibrate = true;
    }
  }

  Future<void> _previewSound(AlarmSoundOption sound) async {
    try {
      await _previewPlayer.stop();

      if (sound.assetPath.startsWith('http')) {
        await _previewPlayer.play(UrlSource(sound.assetPath));
      } else {
        await _previewPlayer.play(AssetSource(sound.assetPath));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not play sound: $e')),
        );
      }
    }
  }

  String _nextAlarmSubtitle() {
    switch (_repeatMode) {
      case 'weekdays':
        return 'Rings every Mon - Fri';
      case 'custom':
        return 'Rings on selected days';
      case 'once':
      default:
        return 'Next alarm in 1 day';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _previewPlayer.dispose();
    super.dispose();
  }

  void _openSoundPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          title: const Text(
            'Choose alarm sound',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: ListView(
              shrinkWrap: true,
              children: alarmSoundOptions.map((sound) {
                final isSelected = _soundId == sound.id;
                return InkWell(
                  onTap: () {
                    setState(() => _soundId = sound.id);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            sound.label,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _previewSound(sound),
                          icon: const Icon(Icons.volume_up,
                              color: Colors.blueAccent, size: 20),
                          tooltip: 'Preview',
                        ),
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 20,
                          color: isSelected ? Colors.green[600] : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _save() {
    final hh = _pickedTime.hour.toString().padLeft(2, '0');
    final mm = _pickedTime.minute.toString().padLeft(2, '0');

    final alarm = AlarmItem(
      id: widget.existing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _nameController.text.isEmpty ? 'Alarm' : _nameController.text,
      time: '$hh:$mm',
      enabled: widget.existing?.enabled ?? true,
      repeatMode: _repeatMode,
      customDays: _customDays.toList(),
      soundId: _soundId,
      vibrate: _vibrate,
    );

    Navigator.of(context).pop(alarm);
  }

  Widget _repeatPill(String label, String value) {
    final isSelected = _repeatMode == value;
    return InkWell(
      onTap: () => setState(() => _repeatMode = value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0F172A),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.blueAccent)),
                    ),
                    Text(widget.existing != null ? 'Edit alarm' : 'New alarm',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    TextButton(
                      onPressed: _save,
                      child: const Text('Done',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    _nextAlarmSubtitle(),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(brightness: Brightness.dark),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: false,
                      initialDateTime: _pickedTime,
                      onDateTimeChanged: (value) {
                        setState(() => _pickedTime = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _repeatPill('Ring once', 'once'),
                      const SizedBox(width: 8),
                      _repeatPill('Weekdays', 'weekdays'),
                      const SizedBox(width: 8),
                      _repeatPill('Scramble!', 'scramble'),
                      const SizedBox(width: 8),
                      _repeatPill('Custom', 'custom'),
                    ],
                  ),
                ),
                if (_repeatMode == 'custom') ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(7, (i) {
                      final day = i + 1;
                      final isSelected = _customDays.contains(day);
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _customDays.remove(day);
                            } else {
                              _customDays.add(day);
                            }
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 42,
                          height: 42,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.amber : Colors.grey[800],
                          ),
                          child: Text(
                            _dayLabels[i],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black : Colors.white70,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Alarm name',
                            hintStyle: TextStyle(color: Colors.white38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[800]),
                      InkWell(
                        onTap: _openSoundPicker,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text('Ringtone',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                              Text(
                                alarmSoundOptions
                                    .firstWhere((s) => s.id == _soundId)
                                    .label,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.chevron_right,
                                  color: Colors.white38, size: 18),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[800]),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('Vibrate',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                            Switch(
                              value: _vibrate,
                              activeColor: Colors.blueAccent,
                              onChanged: (v) => setState(() => _vibrate = v),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Colors.grey[800]),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Snooze',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                            Text('5 minutes, 3 times',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                            SizedBox(width: 6),
                            Icon(Icons.chevron_right,
                                color: Colors.white38, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
