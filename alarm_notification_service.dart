import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'app_timezone.dart';

// ==========================================================
// AlarmNotificationService
//
// "Islamic Alarm & Clock" ফিচারের জন্য দায়ী — অ্যাপ বন্ধ/ব্যাকগ্রাউন্ড/
// ফোন লক থাকলেও alarm সময়ে notification আসার জন্য। আগে alarm শুধু
// অ্যাপ খোলা অবস্থায় (Timer.periodic দিয়ে) কাজ করত — সেটা ঠিক করতেই
// এই সার্ভিস।
//
// প্রতিটা alarm sound-এর জন্য আলাদা channel + res/raw resource
// (azan-এর মতোই), যাতে ফোন লক/অ্যাপ বন্ধ অবস্থাতেও আসল কাস্টম sound
// (bird/duck/cuckoo ইত্যাদি) বাজে, শুধু ডিফল্ট notification sound না।
//
// ⚠️ android/app/src/main/res/raw/-এ এই ফাইলগুলো থাকতে হবে:
// alarm_default.mp3, alarm_bird.mp3, alarm_duck.mp3, alarm_cuckoo.mp3
// (assets/audio/-এর একই mp3 কপি করে বসাতে হবে)। tone1/tone2/rooster-এর
// জন্য এখনো mp3 ফাইল নেই, তাই সেগুলো raw resource ছাড়া ডিফল্ট
// channel-এই থেকে যাবে যতক্ষণ না ফাইল যোগ হয়।
// ==========================================================
class AlarmSoundChannel {
  final String soundId; // AlarmSoundOption.id এর সাথে মিলবে
  final String rawResourceName; // null হলে raw resource নেই

  const AlarmSoundChannel(
      {required this.soundId, required this.rawResourceName});

  String get channelId => 'nur_alarm_channel_$soundId';
}

const List<AlarmSoundChannel> alarmSoundChannels = [
  AlarmSoundChannel(soundId: 'default', rawResourceName: 'alarm_default'),
  AlarmSoundChannel(soundId: 'bird', rawResourceName: 'alarm_bird'),
  AlarmSoundChannel(soundId: 'duck', rawResourceName: 'alarm_duck'),
  AlarmSoundChannel(soundId: 'cuckoo', rawResourceName: 'alarm_cuckoo'),
  // tone1/tone2/rooster: raw resource না থাকায় এখনো যোগ করা হয়নি
];

class AlarmNotificationService {
  AlarmNotificationService._();
  static final AlarmNotificationService instance = AlarmNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String channelId = 'nur_alarm_channel';
  static const String channelName = 'অ্যালার্ম';
  static const String channelDesc = 'Islamic Alarm & Clock নোটিফিকেশন';
  static const String pendingAlarmPrefsKey = 'nur_pending_alarm_id';

  // অ্যাপ চালু থাকা অবস্থায় notification ট্যাপ হলে সাথে সাথে জানানোর
  // জন্য — alarm_list_section.dart এটা listen করে।
  final ValueNotifier<String?> lastTappedAlarmId = ValueNotifier<String?>(null);

  Future<void> init() async {
    if (_initialized) return;

    await initAppTimezone();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload == null) return;
        lastTappedAlarmId.value = payload;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(pendingAlarmPrefsKey, payload);
      },
    );

    // অ্যাপ সম্পূর্ণ বন্ধ থাকা অবস্থায় notification ট্যাপ করে অ্যাপ
    // চালু হলে launch details থেকে payload ধরার জন্য।
    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(pendingAlarmPrefsKey, payload);
      }
    }

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // প্রতিটা raw-resource-ওয়ালা sound-এর জন্য আলাদা channel
    for (final sc in alarmSoundChannels) {
      final channel = AndroidNotificationChannel(
        sc.channelId,
        '$channelName (${sc.soundId})',
        description: channelDesc,
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(sc.rawResourceName),
      );
      await androidImpl?.createNotificationChannel(channel);
    }

    // raw resource নেই এমন sound (tone1/tone2/rooster/মিউট না-করা অজানা
    // id) -এর জন্য ডিফল্ট system sound দিয়ে fallback channel
    const fallbackChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDesc,
      importance: Importance.max,
      playSound: true,
    );
    await androidImpl?.createNotificationChannel(fallbackChannel);

    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();

    // Android 14+ এ fullScreenIntent শুধু manifest-এ declare করলেই কাজ
    // করে না — রানটাইমে আলাদাভাবে এই permission-টা চাইতে হয়, নাহলে
    // Android চুপচাপ সাধারণ notification-এ নামিয়ে দেয় (azan-এর জন্য
    // আগে একই কারণে পপ-আপ আসছিল না, একই fix এখানেও লাগবে)।
    try {
      await androidImpl?.requestFullScreenIntentPermission();
    } catch (_) {
      // পুরনো Android ভার্সনে এই মেথড না থাকতে পারে — ইগনোর করাই ঠিক।
    }

    _initialized = true;
  }

  // ==========================================================
  // App restart হলে আগে save করা pending alarm id (notification tap
  // থেকে) একবার পড়ে, prefs থেকে মুছে ফেলে।
  // ==========================================================
  Future<String?> consumePendingAlarmId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(pendingAlarmPrefsKey);
    if (id != null) {
      await prefs.remove(pendingAlarmPrefsKey);
    }
    return id;
  }

  int _idFor(String alarmId, int day) {
    // day: 0 = once (non-repeating), 1-7 = সপ্তাহের নির্দিষ্ট দিন
    return (alarmId.hashCode.abs() % 100000) * 10 + day;
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  tz.TZDateTime _nextInstanceOfWeekday(int hour, int minute, int weekday) {
    var scheduled = _nextInstanceOfTime(hour, minute);
    while (scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  NotificationDetails _detailsFor(String soundId) {
    final match = alarmSoundChannels.where((sc) => sc.soundId == soundId);
    final chosenChannelId =
        match.isNotEmpty ? match.first.channelId : channelId;
    final chosenChannelName = match.isNotEmpty
        ? '$channelName (${match.first.soundId})'
        : channelName;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        chosenChannelId,
        chosenChannelName,
        channelDescription: channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.alarm,
      ),
    );
  }

  // ==========================================================
  // একটা alarm schedule করে — repeatMode অনুযায়ী once/weekdays/custom।
  // soundId অনুযায়ী সঠিক raw-resource channel বেছে নেয়, যাতে ফোন লক
  // থাকলেও আসল কাস্টম sound বাজে। আগে থেকে schedule করা থাকলে আগে
  // cancel করে নতুন করে বসায়।
  // ==========================================================
  Future<void> scheduleAlarm({
    required String alarmId,
    required String title,
    required int hour,
    required int minute,
    required String repeatMode,
    List<int> customDays = const [],
    String soundId = 'default',
  }) async {
    if (!_initialized) await init();
    await cancelAlarm(alarmId);

    final details = _detailsFor(soundId);

    if (repeatMode == 'weekdays') {
      for (int day = 1; day <= 5; day++) {
        await _scheduleOne(
          id: _idFor(alarmId, day),
          title: title,
          scheduled: _nextInstanceOfWeekday(hour, minute, day),
          payload: alarmId,
          repeatWeekly: true,
          details: details,
        );
      }
    } else if (repeatMode == 'custom' && customDays.isNotEmpty) {
      for (final day in customDays) {
        await _scheduleOne(
          id: _idFor(alarmId, day),
          title: title,
          scheduled: _nextInstanceOfWeekday(hour, minute, day),
          payload: alarmId,
          repeatWeekly: true,
          details: details,
        );
      }
    } else {
      // 'once' (এবং 'scramble' আপাতত once-এর মতোই ব্যবহার হচ্ছে)
      await _scheduleOne(
        id: _idFor(alarmId, 0),
        title: title,
        scheduled: _nextInstanceOfTime(hour, minute),
        payload: alarmId,
        repeatWeekly: false,
        details: details,
      );
    }
  }

  Future<void> _scheduleOne({
    required int id,
    required String title,
    required tz.TZDateTime scheduled,
    required String payload,
    required bool repeatWeekly,
    required NotificationDetails details,
  }) async {
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        'অ্যালার্ম বাজছে',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            repeatWeekly ? DateTimeComponents.dayOfWeekAndTime : null,
        payload: payload,
      );
    } catch (_) {
      // exact permission না থাকলে inexact দিয়ে fallback
      await _plugin.zonedSchedule(
        id,
        title,
        'অ্যালার্ম বাজছে',
        scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:
            repeatWeekly ? DateTimeComponents.dayOfWeekAndTime : null,
        payload: payload,
      );
    }
  }

  // ==========================================================
  // একটা alarm-এর সব schedule বাতিল করে (once + সপ্তাহের ৭ দিনের
  // সম্ভাব্য সব id — যেটা যেভাবেই schedule হয়ে থাকুক)।
  // ==========================================================
  Future<void> cancelAlarm(String alarmId) async {
    for (int day = 0; day <= 7; day++) {
      await _plugin.cancel(_idFor(alarmId, day));
    }
  }
}
