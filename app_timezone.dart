import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:flutter_timezone/flutter_timezone.dart';

// ==========================================================
// timezone প্যাকেজ ডিফল্টভাবে "local location" হিসেবে UTC ধরে নেয়,
// যতক্ষণ না সুনির্দিষ্টভাবে setLocalLocation() দিয়ে device-এর আসল
// timezone (যেমন "Europe/Rome") বসানো হয়। আগে কোডে
// `tz.setLocalLocation(tz.local)` লেখা ছিল, যেটা আসলে UTC-কে
// নিজের সাথেই সেট করছিল — কোনো real device timezone বসছিল না।
// এর ফলে exact schedule করা সব notification (azan + alarm) UTC
// সময় ধরে schedule হচ্ছিল, device local সময় না — ইতালিতে (UTC+2,
// গ্রীষ্মকালে) এই কারণেই প্রতিটা notification ঠিক ২ ঘণ্টা দেরিতে
// আসছিল।
//
// এই ফাংশন flutter_timezone প্যাকেজ দিয়ে device-এর আসল IANA
// timezone নাম বের করে সঠিকভাবে সেট করে।
// ==========================================================
bool _appTimezoneInitialized = false;

Future<void> initAppTimezone() async {
  if (_appTimezoneInitialized) return;

  tzdata.initializeTimeZones();

  try {
    final info = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(info.identifier));
  } catch (_) {
    // timezone নাম বের করতে বা match করতে ব্যর্থ হলে UTC-ই থেকে
    // যাবে — app crash করবে না, কিন্তু সময় ভুল হতে পারে।
  }

  _appTimezoneInitialized = true;
}
