import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';
import 'package:hijri/hijri_calendar.dart';
import 'prayer_times.dart';
import 'cities_data.dart';
import 'app_timezone.dart';
import 'azan_alarm_screen.dart';

// ==========================================================
// AzanNotificationService
//
// অ্যাপ বন্ধ/ব্যাকগ্রাউন্ড থাকলেও নামাজের ওয়াক্ত হলে notification-এ
// আজান বাজানোর জন্য দায়ী। প্রতিদিন আজ + আগামীকালের ৫ ওয়াক্তের
// notification schedule করে (device timezone অনুযায়ী)।
//
// ⚠️ গুরুত্বপূর্ণ: android/app/src/main/res/raw/adhan.mp3 ফাইলটা
// আলাদাভাবে বসাতে হবে (assets/audio/adhan.mp3 থেকে কপি করে)।
// notification sound শুধু res/raw থেকেই কাজ করে, Flutter asset থেকে না।
// ==========================================================
// ==========================================================
// আজানের ভয়েস অপশন — প্রতিটার জন্য res/raw এ আলাদা mp3 লাগবে,
// আর প্রতিটার জন্য আলাদা notification channel (Android channel
// sound একবার সেট হলে বদলানো যায় না, তাই আলাদা channel দরকার)।
// ==========================================================
class AzanVoiceOption {
  final String id;
  final String labelBangla;
  final String rawResourceName; // res/raw/<name>.mp3 -- .mp3 ছাড়া শুধু নাম

  const AzanVoiceOption({
    required this.id,
    required this.labelBangla,
    required this.rawResourceName,
  });

  String get channelId => 'azan_channel_$id';
}

const List<AzanVoiceOption> azanVoiceOptions = [
  AzanVoiceOption(
    id: 'makkah',
    labelBangla: 'মক্কা শরীফ',
    rawResourceName: 'adhan_makkah',
  ),
  AzanVoiceOption(
    id: 'madina',
    labelBangla: 'মদিনা শরীফ',
    rawResourceName: 'adhan_madina',
  ),
  AzanVoiceOption(
    id: 'bangladesh',
    labelBangla: 'বাংলাদেশি মুয়াজ্জিন',
    rawResourceName: 'adhan_bangladesh',
  ),
];

class AzanNotificationService {
  AzanNotificationService._();
  static final AzanNotificationService instance = AzanNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // main.dart থেকে সেট হবে — payload পাওয়ার পর এই navigator দিয়েই
  // AzanAlarmScreen push করা হবে।
  GlobalKey<NavigatorState>? navigatorKey;

  final AudioPlayer _alarmPlayer = AudioPlayer();
  bool _isAlarmPlaying = false;

  // আজানের পর্দা খোলার পর এতক্ষণ (সেকেন্ড) পরে নিজে থেকে বন্ধ হয়ে যাবে,
  // আর আজানের সাউন্ডও থেমে যাবে। কমাতে/বাড়াতে শুধু এই সংখ্যাটা বদলান।
  static const int azanScreenAutoCloseSeconds = 180;
  Timer? _autoCloseTimer;

  bool _initialized = false;

  static const String channelName = 'আযান';
  static const String channelDesc = 'নামাজের সময় আযান নোটিফিকেশন';
  static const String prefsPrayerChoiceKey = 'nur_prayer_azan_choice';
  static const String defaultAzanVoiceId = 'madina';
  static const String muteValue = 'none';
  static const String debugScheduleLogKey = 'nur_azan_debug_schedule_log';

  Future<void> init() async {
    if (_initialized) return;

    await initAppTimezone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        _handleNotificationPayload(response.payload);
      },
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // প্রতিটা আজান ভয়েসের জন্য আলাদা channel — যাতে ইউজার সেটিংসে
    // ভয়েস বদলালে সঠিক sound-ওয়ালা channel ব্যবহার করা যায়।
    for (final voice in azanVoiceOptions) {
      final channel = AndroidNotificationChannel(
        voice.channelId,
        '$channelName (${voice.labelBangla})',
        description: channelDesc,
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(voice.rawResourceName),
      );
      await androidImpl?.createNotificationChannel(channel);
    }

    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    // আজানের সময় ফোনের স্ক্রিন নিজে থেকে জ্বলবে না (fullScreenIntent
    // ব্যবহার করা হয় না), তাই এখানে full-screen পারমিশন চাওয়ার দরকার নেই।

    _initialized = true;
  }

  // ==========================================================
  // অ্যাপ বন্ধ অবস্থায় (terminated) notification ট্যাপ করে অ্যাপ খোলা
  // হলে flutter_local_notifications-এর সাধারণ callback কাজ করে না —
  // main()-এ app শুরু হওয়ার পর এই মেথডটা কল করে চেক করতে হয় অ্যাপ
  // কি কোনো notification ট্যাপ করে খোলা হয়েছে কিনা।
  // ==========================================================
  Future<void> checkAppLaunchFromNotification() async {
    if (!_initialized) await init();
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse?.payload != null) {
      // এক ফ্রেম পরে চালানো — যাতে navigatorKey-এর widget tree রেডি থাকে।
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationPayload(details.notificationResponse!.payload);
      });
    }
  }

  // ==========================================================
  // notification-এর payload (prayer key + ভয়েস) থেকে আসল প্রেয়ার
  // টাইম হিসাব করে AzanAlarmScreen পুশ করে, আর আজানের সাউন্ড লুপে
  // বাজানো শুরু করে। কিছুক্ষণ (azanScreenAutoCloseSeconds) পর পর্দা
  // ও সাউন্ড নিজে থেকে বন্ধ হয়ে যায়।
  // ==========================================================
  Future<void> _handleNotificationPayload(String? payload) async {
    if (payload == null) return;
    final nav = navigatorKey?.currentState;
    if (nav == null) return;

    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      final prayerKey = data['key'] as String;
      final nameBangla = data['nameBangla'] as String;
      final voiceRaw = data['voiceRaw'] as String? ?? 'adhan_madina';

      final prefs = await SharedPreferences.getInstance();
      final savedCityStr = prefs.getString('nur_city');
      final calcMethod =
          prefs.getString('nur_calc_method') ?? 'IslamicFoundation';

      final city = savedCityStr != null
          ? CityLocation.fromJson(jsonDecode(savedCityStr))
          : defaultCity;

      final today =
          calculatePrayerTimes(city.lat, city.lng, method: calcMethod);

      final prayerTimeMap = {
        'fajr': today.fajr,
        'dhuhr': today.dhuhr,
        'asr_shafi': today.asr,
        'asr_hanafi': today.asrHanafi,
        'maghrib': today.maghrib,
        'isha': today.isha,
      };
      final orderedKeys = [
        'fajr',
        'dhuhr',
        'asr_shafi',
        'asr_hanafi',
        'maghrib',
        'isha'
      ];
      final orderedNames = {
        'fajr': 'ফজর',
        'dhuhr': 'যোহর',
        'asr_shafi': 'আসর (শাফেয়ী)',
        'asr_hanafi': 'আসর (হানাফি)',
        'maghrib': 'মাগরিব',
        'isha': 'এশা',
      };

      final currentIndex = orderedKeys.indexOf(prayerKey);
      final nextIndex = (currentIndex + 1) % orderedKeys.length;
      final nextKey = orderedKeys[nextIndex];

      final now = DateTime.now();
      final currentTimeStr =
          '${_toBanglaNumber(now.hour.toString().padLeft(2, '0'))}:${_toBanglaNumber(now.minute.toString().padLeft(2, '0'))}';

      const banglaMonths = [
        'জানুয়ারি',
        'ফেব্রুয়ারি',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টেম্বর',
        'অক্টোবর',
        'নভেম্বর',
        'ডিসেম্বর',
      ];
      final gregorianDateStr =
          'আজ ${_toBanglaNumber(now.day.toString())} ${banglaMonths[now.month - 1]}, ${_toBanglaNumber(now.year.toString())}';

      final hijri = HijriCalendar.fromDate(now);
      final hijriDateStr =
          '${_toBanglaNumber(hijri.hDay.toString())} ${hijri.longMonthName} ${_toBanglaNumber(hijri.hYear.toString())} হিজরি';

      await playAlarmLoop(voiceRaw);

      final route = MaterialPageRoute<void>(
        builder: (_) => AzanAlarmScreen(
          prayerNameBangla: nameBangla,
          currentTimeStr: currentTimeStr,
          gregorianDateStr: gregorianDateStr,
          hijriDateStr: hijriDateStr,
          cityName: city.nameEnglish,
          waqtTimeStr: prayerTimeMap[prayerKey] ?? '',
          adjustmentStr: '০ মিনিট',
          alarmTimeStr: prayerTimeMap[prayerKey] ?? '',
          hadithQuote: 'নামায হলো জান্নাতের চাবি।',
          hadithSource: 'সুনানে তিরমিজি',
          nextPrayerNameBangla: orderedNames[nextKey] ?? '',
          nextPrayerTimeStr: prayerTimeMap[nextKey] ?? '',
          onDismiss: () async {
            _autoCloseTimer?.cancel();
            await stopAlarmLoop();
            if (nav.canPop()) nav.pop();
          },
        ),
      );

      nav.push(route);

      // কিছুক্ষণ পর নিজে থেকে বন্ধ: সাউন্ড থামে, আর পর্দাটা এখনো খোলা
      // থাকলে শুধু ওই পর্দাটাই সরানো হয় (অন্য কোনো পাতা বন্ধ হয় না)।
      _autoCloseTimer?.cancel();
      _autoCloseTimer = Timer(
        const Duration(seconds: azanScreenAutoCloseSeconds),
        () async {
          await stopAlarmLoop();
          if (route.isActive) nav.removeRoute(route);
        },
      );
    } catch (_) {
      // payload parse ব্যর্থ হলে চুপচাপ ইগনোর — সাধারণ notification-ই থেকে যাবে।
    }
  }

  // ==========================================================
  // আজানের mp3 (Flutter asset হিসেবে assets/audio/<name>.mp3 তে
  // থাকতে হবে) লুপে বাজানো শুরু করে, ব্যবহারকারী স্লাইড করে বন্ধ না
  // করা পর্যন্ত (বা auto-close সময় পর্যন্ত) চলতেই থাকবে।
  // ==========================================================
  Future<void> playAlarmLoop(String rawResourceName) async {
    if (_isAlarmPlaying) return;
    _isAlarmPlaying = true;
    try {
      await _alarmPlayer.setReleaseMode(ReleaseMode.loop);
      await _alarmPlayer.play(AssetSource('audio/$rawResourceName.mp3'));
    } catch (_) {
      _isAlarmPlaying = false;
    }
  }

  Future<void> stopAlarmLoop() async {
    if (!_isAlarmPlaying) return;
    _isAlarmPlaying = false;
    try {
      await _alarmPlayer.stop();
    } catch (_) {}
  }

  // ==========================================================
  // প্রতিটা ওয়াক্তের জন্য আলাদা আলাদা আজান ভয়েস (বা মিউট) সিলেক্ট
  // করার জন্য। key: prayer key ('fajr', 'dhuhr', 'asr_shafi',
  // 'asr_hanafi', 'maghrib', 'isha') → value: voice id অথবা 'none'
  // (মিউট)। কোনো key না থাকলে ডিফল্ট ভয়েস ধরা হয়।
  // ==========================================================
  Future<Map<String, String>> getPrayerVoiceChoices() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(prefsPrayerChoiceKey);
    if (saved == null) return {};
    try {
      final decoded = jsonDecode(saved) as Map<String, dynamic>;
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  Future<String> getPrayerVoiceChoice(String prayerKey) async {
    final choices = await getPrayerVoiceChoices();
    return choices[prayerKey] ?? defaultAzanVoiceId;
  }

  Future<void> setPrayerVoiceChoice(String prayerKey, String voiceId) async {
    final prefs = await SharedPreferences.getInstance();
    final choices = await getPrayerVoiceChoices();
    choices[prayerKey] = voiceId;
    await prefs.setString(prefsPrayerChoiceKey, jsonEncode(choices));
  }

  // ==========================================================
  // আজ + আগামীকালের ৫ ওয়াক্তের notification schedule করে।
  // প্রতিবার app open/city change/mute toggle হলে এটা কল করা উচিত —
  // পুরনো সব schedule cancel করে নতুন করে বসায়।
  //
  // পুরো বডি try-catch দিয়ে মোড়া, যাতে মাঝপথে কোনো crash হলেও
  // সেটা debug log-এ সেভ হয় (আগে crash হলে log-ই লেখা হতো না,
  // তাই "কোনো log নেই" দেখাত)।
  // ==========================================================
  Future<void> scheduleUpcomingPrayers({
    required double lat,
    required double lng,
    required String calculationMethod,
  }) async {
    final logLines = <String>[
      'Schedule শুরু: ${DateTime.now()}',
    ];

    try {
      if (!_initialized) await init();

      await _plugin.cancelAll();

      final voiceChoices = await getPrayerVoiceChoices();

      final today = calculatePrayerTimes(lat, lng, method: calculationMethod);
      final tomorrow = calculatePrayerTimes(
        lat,
        lng,
        method: calculationMethod,
        date: DateTime.now().add(const Duration(days: 1)),
      );

      final entries = <Map<String, Object>>[
        {'key': 'fajr', 'nameBangla': 'ফজর', 'time': today.fajr, 'day': 0},
        {'key': 'dhuhr', 'nameBangla': 'যোহর', 'time': today.dhuhr, 'day': 0},
        {
          'key': 'asr_shafi',
          'nameBangla': 'আসর (শাফেয়ী)',
          'time': today.asr,
          'day': 0
        },
        {
          'key': 'asr_hanafi',
          'nameBangla': 'আসর (হানাফি)',
          'time': today.asrHanafi,
          'day': 0
        },
        {
          'key': 'maghrib',
          'nameBangla': 'মাগরিব',
          'time': today.maghrib,
          'day': 0
        },
        {'key': 'isha', 'nameBangla': 'এশা', 'time': today.isha, 'day': 0},
        {'key': 'fajr', 'nameBangla': 'ফজর', 'time': tomorrow.fajr, 'day': 1},
        {
          'key': 'dhuhr',
          'nameBangla': 'যোহর',
          'time': tomorrow.dhuhr,
          'day': 1
        },
        {
          'key': 'asr_shafi',
          'nameBangla': 'আসর (শাফেয়ী)',
          'time': tomorrow.asr,
          'day': 1
        },
        {
          'key': 'asr_hanafi',
          'nameBangla': 'আসর (হানাফি)',
          'time': tomorrow.asrHanafi,
          'day': 1
        },
        {
          'key': 'maghrib',
          'nameBangla': 'মাগরিব',
          'time': tomorrow.maghrib,
          'day': 1
        },
        {'key': 'isha', 'nameBangla': 'এশা', 'time': tomorrow.isha, 'day': 1},
      ];

      int notificationId = 1000;

      for (final entry in entries) {
        final key = entry['key'] as String;
        final label = '${entry['nameBangla']}(day${entry['day']})';

        final choice = voiceChoices[key] ?? defaultAzanVoiceId;
        if (choice == muteValue) {
          logLines.add('$label: মিউট (skip)');
          continue;
        }

        final voice = azanVoiceOptions.firstWhere(
          (v) => v.id == choice,
          orElse: () => azanVoiceOptions.first,
        );

        final timeStr = entry['time'] as String;
        final addDays = entry['day'] as int;

        final scheduled = _resolveScheduledTime(timeStr, addDays: addDays);
        if (scheduled == null) {
          logLines.add('$label: সময় parse ব্যর্থ ("$timeStr") — skip');
          continue;
        }

        if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {
          logLines.add('$label: $scheduled ইতিমধ্যে পার হয়ে গেছে — skip');
          continue;
        }

        // fullScreenIntent ইচ্ছাকৃতভাবে নেই — স্ক্রিন বন্ধ থাকলে জ্বলবে না,
        // শুধু আওয়াজ ও নোটিফিকেশন আসবে।
        final details = NotificationDetails(
          android: AndroidNotificationDetails(
            voice.channelId,
            '$channelName (${voice.labelBangla})',
            channelDescription: channelDesc,
            importance: Importance.max,
            priority: Priority.high,
            sound: RawResourceAndroidNotificationSound(voice.rawResourceName),
            playSound: true,
            category: AndroidNotificationCategory.alarm,
          ),
        );

        final payload = jsonEncode({
          'key': key,
          'nameBangla': entry['nameBangla'],
          'voiceRaw': voice.rawResourceName,
        });

        try {
          await _plugin.zonedSchedule(
            notificationId++,
            '${entry['nameBangla']} নামাজের সময় হয়েছে',
            'আযান শুরু হয়েছে — নামাজের জন্য প্রস্তুত হোন',
            scheduled,
            details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: payload,
          );
          logLines.add('$label: exact @ $scheduled');
        } catch (e) {
          // Exact alarm permission না থাকলে exception আসে — তখন approximate
          // সময়ে (কয়েক মিনিট আগে/পরে) হলেও notification যাতে আসে, সেজন্য
          // inexact মোডে fallback schedule করা হচ্ছে।
          try {
            await _plugin.zonedSchedule(
              notificationId++,
              '${entry['nameBangla']} নামাজের সময় হয়েছে',
              'আযান শুরু হয়েছে — নামাজের জন্য প্রস্তুত হোন',
              scheduled,
              details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
              payload: payload,
            );
            logLines.add('$label: inexact @ $scheduled (exact error: $e)');
          } catch (e2) {
            logLines
                .add('$label: FAILED @ $scheduled — exact=[$e] inexact=[$e2]');
          }
        }
      }

      logLines.add('Schedule সম্পন্ন ✅');
    } catch (e, stack) {
      // এখানে ধরা পড়লে বোঝা যাবে ঠিক কোথায় পুরো ফাংশনটা crash করেছে।
      logLines.add('❌ CRASH: $e');
      logLines
          .add('Stack: ${stack.toString().split('\n').take(5).join(' | ')}');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(debugScheduleLogKey, logLines.join('\n'));
  }

  // ==========================================================
  // ডিবাগ — সর্বশেষ scheduleUpcomingPrayers() কল কোন কোন ওয়াক্ত
  // exact/inexact/failed মোডে schedule হয়েছিল তা দেখার জন্য।
  // ==========================================================
  Future<String> getDebugScheduleLog() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(debugScheduleLogKey) ??
        'এখনো কোনো schedule log নেই।';
  }

  tz.TZDateTime? _resolveScheduledTime(String timeStr, {int addDays = 0}) {
    final parts = timeStr.trim().split(' ');
    if (parts.length < 2) return null;

    final hm = parts[0].split(':');
    if (hm.length < 2) return null;

    int hour = int.tryParse(hm[0]) ?? -1;
    final minute = int.tryParse(hm[1]) ?? -1;

    if (hour < 0 || minute < 0) return null;

    final period = parts[1].toUpperCase();

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    final now = tz.TZDateTime.now(tz.local);

    return tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day + addDays,
      hour,
      minute,
    );
  }

  // ==========================================================
  // ডিবাগ/টেস্ট — নামাজের সময়ের জন্য অপেক্ষা না করে, এখনই ৩০ সেকেন্ড
  // পরে একটা নোটিফিকেশন schedule করে। কাজ করছে কিনা দ্রুত যাচাই করতে।
  // return: 'exact' | 'inexact' | অথবা 'failed: ...' (আসল error সহ)
  // ==========================================================
  Future<String> scheduleTestNotification() async {
    if (!_initialized) await init();

    final scheduled =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 30));

    final voice = azanVoiceOptions.firstWhere((v) => v.id == 'madina');
    final testPayload = jsonEncode({
      'key': 'dhuhr',
      'nameBangla': 'টেস্ট ওয়াক্ত',
      'voiceRaw': voice.rawResourceName,
    });

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        voice.channelId,
        '$channelName (${voice.labelBangla})',
        channelDescription: channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(voice.rawResourceName),
        playSound: true,
        category: AndroidNotificationCategory.alarm,
      ),
    );

    try {
      await _plugin.zonedSchedule(
        9999,
        'টেস্ট নোটিফিকেশন',
        'এটা এসেছে মানে scheduling ঠিকমতো কাজ করছে (exact)',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: testPayload,
      );
      return 'exact';
    } catch (e) {
      try {
        await _plugin.zonedSchedule(
          9999,
          'টেস্ট নোটিফিকেশন',
          'এটা এসেছে মানে scheduling কাজ করছে (inexact — exact alarm permission অন করো)',
          scheduled,
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: testPayload,
        );
        return 'inexact';
      } catch (e2) {
        return 'failed: exact=[$e] inexact=[$e2]';
      }
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ==========================================================
  // ইংরেজি সংখ্যাকে বাংলা সংখ্যায় রূপান্তর করে (তারিখ/সময় দেখানোর জন্য)।
  // ==========================================================
  String _toBanglaNumber(String number) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bn = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var result = number;
    for (var i = 0; i < en.length; i++) {
      result = result.replaceAll(en[i], bn[i]);
    }
    return result;
  }
}
