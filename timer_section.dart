import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerPreset {
  final String name;
  final int seconds;

  const TimerPreset({required this.name, required this.seconds});

  Map<String, dynamic> toJson() => {'name': name, 'seconds': seconds};

  factory TimerPreset.fromJson(Map<String, dynamic> json) => TimerPreset(
        name: json['name'],
        seconds: json['seconds'],
      );
}

class TimerSection extends StatefulWidget {
  const TimerSection({super.key});

  @override
  State<TimerSection> createState() => _TimerSectionState();
}

class _TimerSectionState extends State<TimerSection> {
  Duration _pickedDuration = const Duration(minutes: 5);
  int _remainingSeconds = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  bool _finished = false;

  Timer? _timer;

  List<TimerPreset> _presets = [
    const TimerPreset(name: 'Brush teeth', seconds: 120),
    const TimerPreset(name: 'Boil eggs', seconds: 600),
    const TimerPreset(name: 'Face mask', seconds: 900),
    const TimerPreset(name: 'Nap', seconds: 1800),
  ];

  @override
  void initState() {
    super.initState();
    _loadPresets();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('nur_timer_presets');
    if (saved != null) {
      final decoded = jsonDecode(saved) as List;
      setState(() {
        _presets = decoded.map((e) => TimerPreset.fromJson(e)).toList();
      });
    }
  }

  Future<void> _savePresets() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'nur_timer_presets',
      jsonEncode(_presets.map((p) => p.toJson()).toList()),
    );
  }

  void _addPresetFromCurrentDuration() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F172A),
          title: const Text('Name this timer',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'e.g. Tea steeping',
              hintStyle: TextStyle(color: Colors.white38),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim().isEmpty
                    ? 'Timer'
                    : controller.text.trim();
                setState(() {
                  _presets = [
                    ..._presets,
                    TimerPreset(name: name, seconds: _pickedDuration.inSeconds),
                  ];
                });
                _savePresets();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editPreset(int index) {
    final preset = _presets[index];
    final nameController = TextEditingController(text: preset.name);
    Duration pickedDuration = Duration(seconds: preset.seconds);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0F172A),
              title: const Text('Edit timer',
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Timer name',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                            brightness: Brightness.dark),
                        child: CupertinoTimerPicker(
                          mode: CupertinoTimerPickerMode.hms,
                          initialTimerDuration: pickedDuration,
                          onTimerDurationChanged: (value) {
                            setDialogState(() => pickedDuration = value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim().isEmpty
                        ? 'Timer'
                        : nameController.text.trim();
                    setState(() {
                      _presets[index] = TimerPreset(
                        name: name,
                        seconds: pickedDuration.inSeconds,
                      );
                    });
                    _savePresets();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deletePreset(int index) {
    setState(() => _presets.removeAt(index));
    _savePresets();
  }

  void _startWithSeconds(int seconds) {
    setState(() {
      _pickedDuration = Duration(seconds: seconds);
      _remainingSeconds = seconds;
      _isRunning = true;
      _isPaused = false;
      _finished = false;
    });
    _runTimer();
  }

  void _startFromPicker() {
    final seconds = _pickedDuration.inSeconds;
    if (seconds <= 0) return;
    _startWithSeconds(seconds);
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 1) {
        setState(() => _remainingSeconds -= 1);
      } else {
        timer.cancel();
        setState(() {
          _remainingSeconds = 0;
          _isRunning = false;
          _finished = true;
        });
        // TODO: টাইমার শেষ হলে শব্দ বাজানো এখনো যুক্ত করা হয়নি
      }
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
    });
    _runTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _finished = false;
      _remainingSeconds = 0;
    });
  }

  String _formatTime(int totalSec) {
    final h = totalSec ~/ 3600;
    final m = (totalSec % 3600) ~/ 60;
    final s = totalSec % 60;
    final hh = h.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$hh:$mm:$ss' : '$mm:$ss';
  }

  bool get _showCountdownScreen => _isRunning || _isPaused || _finished;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _showCountdownScreen ? _buildCountdownScreen() : _buildSetupScreen(),
        if (_finished) _buildFinishedModal(),
      ],
    );
  }

  Widget _buildSetupScreen() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(16),
            ),
            child: CupertinoTheme(
              data: const CupertinoThemeData(brightness: Brightness.dark),
              child: CupertinoTimerPicker(
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: _pickedDuration,
                onTimerDurationChanged: (value) {
                  setState(() => _pickedDuration = value);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Expanded(
                child: Text('Frequently used timers',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
              TextButton(
                onPressed: _addPresetFromCurrentDuration,
                child: const Text('Add',
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ..._presets.asMap().entries.map((entry) {
            final index = entry.key;
            final preset = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _presetRow(preset, index),
            );
          }),
          const SizedBox(height: 12),
          Center(
            child: InkWell(
              onTap: _startFromPicker,
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.play_arrow, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _presetRow(TimerPreset preset, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(preset.name,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
          Text(_formatTime(preset.seconds),
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _startWithSeconds(preset.seconds),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              child:
                  const Icon(Icons.play_arrow, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => _editPreset(index),
            child: Icon(Icons.edit, color: Colors.grey[400], size: 17),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => _deletePreset(index),
            child: Icon(Icons.close, color: Colors.grey[500], size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownScreen() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        children: [
          Text(
            _formatTime(_remainingSeconds),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 56,
              fontWeight: FontWeight.w900,
              color: Colors.green[400],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isRunning ? _pauseTimer : _resumeTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isRunning ? Colors.amber : Colors.green[600],
                  foregroundColor: _isRunning ? Colors.black : Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                label: Text(
                  _isRunning ? 'Pause' : 'Resume',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: _resetTimer,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: const Icon(Icons.restart_alt, color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedModal() {
    return Positioned.fill(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.amber, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                      color: Colors.amber, shape: BoxShape.circle),
                  child: const Icon(Icons.notifications_active,
                      color: Colors.black, size: 32),
                ),
                const SizedBox(height: 16),
                const Text('Timer finished!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                const SizedBox(height: 8),
                const Text('Sound feature not added yet',
                    style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Stop',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
