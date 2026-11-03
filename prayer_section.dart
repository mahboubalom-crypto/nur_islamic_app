import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'prayer_times.dart';
import 'cities_data.dart';
import 'nafl_times.dart';
import 'prayer_arc_card.dart';
import 'qibla.dart';
import 'qibla_section.dart';
import 'azan_notification_service.dart';

class PrayerSection extends StatefulWidget {
  final PrayerTimesData prayerTimes;
  final CityLocation selectedCity;
  final void Function(CityLocation city) setSelectedCity;
  final String calculationMethod;
  final void Function(String method) setCalculationMethod;
  final bool isDarkTheme;
  final Future<void> Function()? onMuteChanged;

  const PrayerSection({
    super.key,
    required this.prayerTimes,
    required this.selectedCity,
    required this.setSelectedCity,
    required this.calculationMethod,
    required this.setCalculationMethod,
    this.isDarkTheme = false,
    this.onMuteChanged,
  });

  @override
  State<PrayerSection> createState() => _PrayerSectionState();
}

class _PrayerSectionState extends State<PrayerSection> {
  bool isPlayingAzan = false;
  bool isPrayerListExpanded = true;

  // key: prayer key ('fajr','dhuhr','asr_shafi','asr_hanafi','maghrib','isha')
  // value: azan voice id (যেমন 'makkah') অথবা 'none' (মিউট)
  Map<String, String> prayerVoiceChoices = {};
  final AudioPlayer _azanPlayer = AudioPlayer()..audioCache.prefix = '';

  @override
  void initState() {
    super.initState();
    _loadPrayerVoiceChoices();
  }

  Future<void> _loadPrayerVoiceChoices() async {
    final choices =
        await AzanNotificationService.instance.getPrayerVoiceChoices();
    if (mounted) {
      setState(() => prayerVoiceChoices = choices);
    }
  }

  Future<void> _setPrayerVoiceChoice(String key, String voiceId) async {
    setState(() {
      prayerVoiceChoices = {...prayerVoiceChoices, key: voiceId};
    });
    await AzanNotificationService.instance.setPrayerVoiceChoice(key, voiceId);
    await widget.onMuteChanged?.call();
  }

  @override
  void dispose() {
    _azanPlayer.dispose();
    super.dispose();
  }

  static const Map<String, String> _methodLabels = {
    'IslamicFoundation': 'ইসলামিক ফাউন্ডেশন বাংলাদেশ',
    'MWL': 'মুসলিম ওয়ার্ল্ড লীগ',
    'Karachi': 'ইসলামিক সায়েন্সেস করাচি',
    'ISNA': 'ইসলামিক সোসাইটি উত্তর আমেরিকা',
    'UmmAlQura': 'উম্মুল কুরা বিশ্ববিদ্যালয় মক্কা',
  };

  // ফিক্স: bangladeshCities আর worldCities মিলিয়ে dropdown এ যদি
  // একই nameEnglish (যেমন "Current Location") দুইবার থেকে যায়,
  // তাহলে DropdownButton crash করত। এখানে duplicate বাদ দিয়ে
  // শুধু unique city গুলো রাখা হচ্ছে।
  List<CityLocation> get _uniqueCities {
    final allCities = [...bangladeshCities, ...worldCities];
    final seen = <String>{};
    return allCities.where((c) => seen.add(c.nameEnglish)).toList();
  }

  // ==========================================================
  // ফরজ নামাযের লিস্ট — শুক্রবারে "যোহর"-এর জায়গায় "জুম'আ" দেখায়,
  // আর আসর এখন দুটো আলাদা রো: (শাফেয়ী) ও (হানাফি)।
  // ==========================================================
  List<Map<String, String>> get _prayersList {
    final isFriday = isJumuahDay;

    return [
      {
        'key': 'fajr',
        'nameBangla': 'ফজর',
        'nameEnglish': 'Fajr',
        'time': widget.prayerTimes.fajr,
        'endTime': widget.prayerTimes.sunrise,
        'description': 'ভোরের সালাত • ২ রাকাত ফরজ',
      },
      {
        'key': 'dhuhr',
        'nameBangla': isFriday ? 'জুম\'আ' : 'যোহর',
        'nameEnglish': isFriday ? 'Jumu\'ah' : 'Dhuhr',
        'time': widget.prayerTimes.dhuhr,
        'endTime': widget.prayerTimes.asr,
        'description': isFriday
            ? 'জুমার নামায • ২ রাকাত ফরজ (খুতবাসহ)'
            : 'দ্বিপ্রহরের সালাত • ৪ রাকাত ফরজ',
      },
      {
        'key': 'asr_shafi',
        'nameBangla': 'আসর (শাফেয়ী)',
        'nameEnglish': 'Asr (Shafii)',
        'time': widget.prayerTimes.asr,
        'endTime': widget.prayerTimes.maghrib,
        'description': 'অপরাহ্ণের সালাত • ৪ রাকাত ফরজ',
      },
      {
        'key': 'asr_hanafi',
        'nameBangla': 'আসর (হানাফি)',
        'nameEnglish': 'Asr (Hanafi)',
        'time': widget.prayerTimes.asrHanafi,
        'endTime': widget.prayerTimes.maghrib,
        'description': 'অপরাহ্ণের সালাত • ৪ রাকাত ফরজ (হানাফি মাযহাব)',
      },
      {
        'key': 'maghrib',
        'nameBangla': 'মাগরিব',
        'nameEnglish': 'Maghrib',
        'time': widget.prayerTimes.maghrib,
        'endTime': widget.prayerTimes.isha,
        'description': 'সূর্যাস্তের সালাত • ৩ রাকাত ফরজ',
      },
      {
        'key': 'isha',
        'nameBangla': 'এশা',
        'nameEnglish': 'Isha',
        'time': widget.prayerTimes.isha,
        'endTime': widget.prayerTimes.fajr,
        'description': 'রাত্রিকালীন সালাত • ৪ রাকাত ফরজ',
      },
    ];
  }

  Map<String, String> get _sunriseInfo => {
        'key': 'sunrise',
        'nameBangla': 'সূর্যোদয়',
        'nameEnglish': 'Sunrise',
        'time': widget.prayerTimes.sunrise,
        'description': 'সূর্য ওঠার সময় • নামাজ নিষিদ্ধ',
      };

  Future<void> _handleTestAzan() async {
    if (isPlayingAzan) {
      await _azanPlayer.stop();

      if (mounted) {
        setState(() {
          isPlayingAzan = false;
        });
      }

      return;
    }

    setState(() {
      isPlayingAzan = true;
    });

    try {
      await _azanPlayer.play(
        AssetSource('audio/adhan.mp3'),
      );

      _azanPlayer.onPlayerComplete.listen((event) {
        if (mounted) {
          setState(() {
            isPlayingAzan = false;
          });
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isPlayingAzan = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('আযান প্লে এরর: $e'),
          ),
        );
      }
    }
  }

  // ==========================================================
  // বেল আইকনে ট্যাপ করলে popup আসে — নির্দিষ্ট ওয়াক্তের জন্য কোন
  // আজান ভয়েস বাজবে (বা মিউট থাকবে) সেটা বেছে নেওয়া যায়।
  // ==========================================================
  void _openVoicePickerFor(String key, String nameBangla) {
    final dark = widget.isDarkTheme;
    final currentChoice =
        prayerVoiceChoices[key] ?? AzanNotificationService.defaultAzanVoiceId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dark ? const Color(0xFF0F172A) : Colors.white,
          title: Text(
            '$nameBangla — আজান বাছাই করুন',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black87,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _voiceOptionTile(
                  label: 'নিরব (মিউট)',
                  isSelected:
                      currentChoice == AzanNotificationService.muteValue,
                  dark: dark,
                  onTap: () {
                    Navigator.of(context).pop();
                    _setPrayerVoiceChoice(
                        key, AzanNotificationService.muteValue);
                  },
                ),
                ...azanVoiceOptions.map(
                  (voice) => _voiceOptionTile(
                    label: voice.labelBangla,
                    isSelected: currentChoice == voice.id,
                    dark: dark,
                    onTap: () {
                      Navigator.of(context).pop();
                      _setPrayerVoiceChoice(key, voice.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('বাতিল'),
            ),
          ],
        );
      },
    );
  }

  Widget _voiceOptionTile({
    required String label,
    required bool isSelected,
    required bool dark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: dark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected ? Colors.green[600] : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  void _openLocationMethodSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: widget.isDarkTheme ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLocationSelector(),
              const SizedBox(height: 12),
              _buildMethodSelector(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeaderBanner(),
        const SizedBox(height: 16),
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              isPrayerListExpanded = !isPrayerListExpanded;
            });
          },
          child: Stack(
            children: [
              PrayerArcCard(
                prayerTimes: widget.prayerTimes,
                isDarkTheme: widget.isDarkTheme,
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: _openLocationMethodSheet,
                  icon: Icon(
                    Icons.tune,
                    size: 20,
                    color: widget.isDarkTheme
                        ? Colors.grey[300]
                        : const Color(0xFF4B5563),
                  ),
                  tooltip: 'স্থান ও পদ্ধতি পরিবর্তন করুন',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isPrayerListExpanded) ...[
          _buildPrayerCards(),
          const SizedBox(height: 16),
        ],
        _buildNaflCards(),
        const SizedBox(height: 16),
        _buildForbiddenTimesCards(),
        const SizedBox(height: 16),
        _buildQiblaCard(),
        const SizedBox(height: 16),
        _buildNaflInfo(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHeaderBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF064E3B),
            Color(0xFF0F2E2A),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.access_time,
                color: Colors.amber,
                size: 22,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'পাঁচ ওয়াক্ত নামাজের সময়সূচি',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'বর্তমান স্থান: ${widget.selectedCity.nameBangla} (${widget.selectedCity.nameEnglish})',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _handleTestAzan,
            style: ElevatedButton.styleFrom(
              backgroundColor: isPlayingAzan ? Colors.amber : Colors.green[800],
              foregroundColor: isPlayingAzan ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(
              Icons.volume_up,
              size: 16,
            ),
            label: Text(
              isPlayingAzan ? 'আযান থামান' : 'আযানের শব্দ শুনুন',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector() {
    // ফিক্স: বর্তমানে বাছাই করা শহর (widget.selectedCity) যদি
    // bangladeshCities/worldCities তালিকায় হুবহু না পাওয়া যায়
    // (যেমন GPS দিয়ে বের করা "Milano"-র মতো শহর), তাহলে আগে চুপচাপ
    // তালিকার প্রথম শহরে (ঢাকা) পড়ে যেত। এখন বর্তমান শহরটাকেই
    // তালিকার শুরুতে যোগ করে দেওয়া হচ্ছে, যাতে dropdown সবসময়
    // সঠিক বর্তমান শহর দেখায়।
    final uniqueCities = _uniqueCities;
    final selectedExistsInList = uniqueCities
        .any((c) => c.nameEnglish == widget.selectedCity.nameEnglish);

    final displayCities = selectedExistsInList
        ? uniqueCities
        : [widget.selectedCity, ...uniqueCities];

    final currentValue = widget.selectedCity.nameEnglish;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[700]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: Colors.green[400],
              ),
              const SizedBox(width: 6),
              const Text(
                'স্থান পরিবর্তন করুন',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[700]!,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                ),
                items: displayCities
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.nameEnglish,
                        child: Text(
                          '${c.nameBangla} (${c.nameEnglish})',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;

                  final found = displayCities
                      .where(
                        (c) => c.nameEnglish == value,
                      )
                      .toList();

                  if (found.isNotEmpty) {
                    widget.setSelectedCity(found.first);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodSelector() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[700]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                size: 14,
                color: Colors.green[400],
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'সময় হিসাবের পদ্ধতি',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey[700]!,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.calculationMethod,
                isExpanded: true,
                dropdownColor: Colors.grey[900],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
                items: _methodLabels.entries
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    widget.setCalculationMethod(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, String>? _getCurrentPrayer() {
    final now = TimeOfDay.now();

    final currentMinutes = now.hour * 60 + now.minute;

    for (final prayer in _prayersList) {
      final start = _parseTime(prayer['time']!);
      final end = _parseTime(prayer['endTime']!);

      if (start == null || end == null) {
        continue;
      }

      if (prayer['key'] == 'isha') {
        if (currentMinutes >= start || currentMinutes < end) {
          return prayer;
        }
      } else if (currentMinutes >= start && currentMinutes < end) {
        return prayer;
      }
    }

    return null;
  }

  int? _parseTime(String value) {
    try {
      final cleaned = value.trim().toLowerCase();

      final isPm = cleaned.contains('pm') || cleaned.contains('p.m');

      final isAm = cleaned.contains('am') || cleaned.contains('a.m');

      final numbers = RegExp(r'\d+')
          .allMatches(cleaned)
          .map((m) => int.parse(m.group(0)!))
          .toList();

      if (numbers.length < 2) {
        return null;
      }

      int hour = numbers[0];
      final minute = numbers[1];

      if (isPm && hour < 12) {
        hour += 12;
      }

      if (isAm && hour == 12) {
        hour = 0;
      }

      if (hour > 23 || minute > 59) {
        return null;
      }

      return hour * 60 + minute;
    } catch (_) {
      return null;
    }
  }

  Widget _buildPrayerCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.schedule,
              color: Colors.amber,
              size: 17,
            ),
            const SizedBox(width: 6),
            const Expanded(
              child: Text(
                '৫ ওয়াক্ত নামাজের সম্পূর্ণ সময়',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              'শুরু - শেষ',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 9,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._prayersList.map(
          (p) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _prayerRow(
              p,
              isForbidden: false,
            ),
          ),
        ),
        const SizedBox(height: 2),
        _prayerRow(
          _sunriseInfo,
          isForbidden: true,
        ),
      ],
    );
  }

  Widget _prayerRow(
    Map<String, String> p, {
    required bool isForbidden,
  }) {
    final key = p['key']!;
    final currentChoice =
        prayerVoiceChoices[key] ?? AzanNotificationService.defaultAzanVoiceId;
    final isMuted = currentChoice == AzanNotificationService.muteValue;
    final hasRange = p.containsKey('endTime');
    final dark = widget.isDarkTheme;

    final currentPrayer = _getCurrentPrayer();
    final isCurrent =
        !isForbidden && currentPrayer != null && currentPrayer['key'] == key;

    final rowBg = isCurrent
        ? (dark ? Colors.green[900]?.withOpacity(0.55) : Colors.green[50])
        : isForbidden
            ? Colors.red.withOpacity(dark ? 0.08 : 0.06)
            : (dark ? Colors.grey[900]?.withOpacity(0.5) : Colors.white);
    final rowBorder = isCurrent
        ? Colors.green
        : isForbidden
            ? Colors.red.withOpacity(0.25)
            : (dark ? Colors.grey[700]! : const Color(0xFFE1E6E4));
    final titleColor = dark ? Colors.white : const Color(0xFF0F2E2A);
    final descColor = dark ? Colors.grey[500] : const Color(0xFF6B7280);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: rowBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: rowBorder,
          width: isCurrent ? 1.4 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrent
                      ? Colors.green[800]
                      : (dark
                          ? Colors.black.withOpacity(0.2)
                          : const Color(0xFFEFF5F0)),
                ),
                alignment: Alignment.center,
                child: Icon(
                  isForbidden ? Icons.wb_sunny_outlined : Icons.access_time,
                  size: 18,
                  color: isForbidden
                      ? Colors.red[300]
                      : isCurrent
                          ? Colors.white
                          : Colors.green[400],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            p['nameBangla']!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: titleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        if (isCurrent) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green[700],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'এখন',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      p['description']!,
                      style: TextStyle(
                        color: descColor,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    bnTime(p['time']!),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: isForbidden
                          ? Colors.red[dark ? 300 : 400]
                          : isCurrent
                              ? (dark ? Colors.greenAccent : Colors.green[700])
                              : Colors.green[400],
                    ),
                  ),
                  if (hasRange)
                    Text(
                      'শেষ ${bnTime(p['endTime']!)}',
                      style: TextStyle(
                        color: descColor,
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
              if (!isForbidden) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _openVoicePickerFor(key, p['nameBangla']!),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isMuted ? Colors.grey[850] : Colors.green[950],
                      border: Border.all(
                        color: isMuted ? Colors.grey[600]! : Colors.green[600]!,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      isMuted
                          ? Icons.notifications_off_outlined
                          : Icons.notifications_active,
                      size: 15,
                      color: isMuted ? Colors.grey[400] : Colors.green[400],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNaflCards() {
    final dark = widget.isDarkTheme;
    final nafl = calculateNaflTimes(
      widget.prayerTimes,
    );

    final items = [
      {
        'title': 'ইশরাক',
        'icon': Icons.wb_twilight,
        'start': bnTime(nafl.ishraqStart),
        'end': bnTime(nafl.ishraqEnd),
      },
      {
        'title': 'চাশত',
        'icon': Icons.wb_cloudy,
        'start': bnTime(nafl.chashtStart),
        'end': bnTime(nafl.chashtEnd),
      },
      {
        'title': 'যাওয়াল',
        'icon': Icons.wb_sunny,
        'start': bnTime(nafl.zawalTime),
        'end': '--:--',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'নফল নামায',
          style: TextStyle(
            color: dark ? Colors.white : const Color(0xFF0F2E2A),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index < items.length - 1 ? 10 : 0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.grey[900]?.withOpacity(0.5)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: dark ? Colors.grey[700]! : const Color(0xFFE1E6E4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: Colors.amber[dark ? 400 : 700],
                        size: 22,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          color: dark ? Colors.white : const Color(0xFF0F2E2A),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['start'] as String,
                        style: TextStyle(
                          color: Colors.green[dark ? 400 : 700],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item['end'] as String,
                        style: TextStyle(
                          color:
                              dark ? Colors.grey[500] : const Color(0xFF6B7280),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildForbiddenTimesCards() {
    final dark = widget.isDarkTheme;
    final forbiddenTimes = calculateForbiddenTimes(widget.prayerTimes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'নামাযের নিষিদ্ধ সময়',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: forbiddenTimes
              .map(
                (ft) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(dark ? 0.08 : 0.06),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ft.label,
                            style: TextStyle(
                              color:
                                  dark ? Colors.white : const Color(0xFF7A1E1E),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${bnTime(ft.start)} - ${bnTime(ft.end)}',
                            style: TextStyle(
                              color: Colors.red[dark ? 300 : 700],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  // ==========================================================
  // কিবলা — দূরত্ব ও অভিমুখের সামারি কার্ড। এখানে লাইভ কম্পাস
  // ডুপ্লিকেট না করে, বাটনে চাপলে আসল QiblaSection (সেন্সর সহ)
  // পেজে নিয়ে যাওয়া হয়।
  // ==========================================================
  Widget _buildQiblaCard() {
    final dark = widget.isDarkTheme;
    final qiblaData = calculateQibla(
      widget.selectedCity.lat,
      widget.selectedCity.lng,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? Colors.grey[900]?.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: dark ? Colors.grey[700]! : const Color(0xFFE1E6E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.explore, color: Colors.amber, size: 17),
              const SizedBox(width: 6),
              Text(
                'কিবলা কম্পাস',
                style: TextStyle(
                  color: dark ? Colors.white : const Color(0xFF0F2E2A),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'কাবার দূরত্ব',
                      style: TextStyle(
                        color:
                            dark ? Colors.grey[400] : const Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${bnNum(qiblaData.distanceKm.round())} কি.মি.',
                      style: TextStyle(
                        color: dark ? Colors.white : const Color(0xFF0F2E2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'উত্তর দিক থেকে অভিমুখ',
                      style: TextStyle(
                        color:
                            dark ? Colors.grey[400] : const Color(0xFF6B7280),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${bnNum(qiblaData.qiblaBearing.round())}°',
                      style: TextStyle(
                        color: dark ? Colors.white : const Color(0xFF0F2E2A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QiblaSection(
                      selectedCity: widget.selectedCity,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.navigation_outlined, size: 16),
              label: const Text(
                'কিবলা কম্পাস বিস্তারিত',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNaflInfo() {
    final dark = widget.isDarkTheme;
    final items = [
      {
        'title': 'ইশরাকের নামাজ',
        'desc': 'সূর্যোদয়ের ১৫-২০ মিনিট পর থেকে শুরু। (২-৪ রাকাত)',
      },
      {
        'title': 'চাশতের নামাজ (দ্বোহা)',
        'desc': 'সকাল থেকে যোহরের পূর্ব পর্যন্ত আদায় করা যায়।',
      },
      {
        'title': 'তাহাজ্জুদের নামাজ',
        'desc': 'রাতের শেষ তৃতীয়াংশে ফজরের ওয়াক্ত হওয়ার পূর্বে।',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? Colors.grey[900]?.withOpacity(0.5) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: dark ? Colors.grey[700]! : const Color(0xFFE1E6E4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: Colors.amber,
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'গুরুত্বপূর্ণ নফল নামাজের সময়সূচি',
                  style: TextStyle(
                    color: dark ? Colors.white : const Color(0xFF0F2E2A),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: TextStyle(
                      color: Colors.amber[dark ? 400 : 800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['desc']!,
                    style: TextStyle(
                      color: dark ? Colors.white54 : const Color(0xFF4B5563),
                      fontSize: 11,
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
