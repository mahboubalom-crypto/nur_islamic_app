import 'prayer_times.dart';

class NaflTimes {
  final String ishraqStart;
  final String ishraqEnd;
  final String chashtStart;
  final String chashtEnd;
  final String zawalTime;

  const NaflTimes({
    required this.ishraqStart,
    required this.ishraqEnd,
    required this.chashtStart,
    required this.chashtEnd,
    required this.zawalTime,
  });
}

// ---- "h:mm AM/PM" কে দিনের মিনিটে রূপান্তর ----
int _parseToMinutes(String timeStr) {
  final parts = timeStr.split(' ');
  final hm = parts[0].split(':');
  int h = int.parse(hm[0]);
  final m = int.parse(hm[1]);
  final period = parts[1];
  if (period == 'PM' && h < 12) h += 12;
  if (period == 'AM' && h == 12) h = 0;
  return h * 60 + m;
}

// ---- মিনিট থেকে আবার "h:mm AM/PM" ----
String _formatMinutes(int totalMinutes) {
  int mins = totalMinutes % (24 * 60);
  if (mins < 0) mins += 24 * 60;
  int hours = mins ~/ 60;
  final minutes = mins % 60;
  final period = hours >= 12 ? 'PM' : 'AM';
  final displayHours = hours % 12 == 0 ? 12 : hours % 12;
  final minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
  return '$displayHours:$minutesStr $period';
}

// ⚠️ নফল নামাজের সময় নিয়ে ভিন্ন ভিন্ন মত আছে, এটা প্রচলিত একটা সাধারণ হিসাব
NaflTimes calculateNaflTimes(PrayerTimesData prayerTimes) {
  final sunriseMin = _parseToMinutes(prayerTimes.sunrise);
  final dhuhrMin = _parseToMinutes(prayerTimes.dhuhr);

  final ishraqStart = sunriseMin + 15;
  final chashtStart = sunriseMin + ((dhuhrMin - sunriseMin) ~/ 2);
  final duhaEnd = dhuhrMin - 10;

  return NaflTimes(
    ishraqStart: _formatMinutes(ishraqStart),
    ishraqEnd: _formatMinutes(duhaEnd),
    chashtStart: _formatMinutes(chashtStart),
    chashtEnd: _formatMinutes(duhaEnd),
    zawalTime: prayerTimes.dhuhr,
  );
}

// ==========================================================
// নামাজের নিষিদ্ধ সময় (Makruh time) হিসাব
// ==========================================================
class ForbiddenTime {
  final String label;
  final String start;
  final String end;

  const ForbiddenTime(
      {required this.label, required this.start, required this.end});
}

List<ForbiddenTime> calculateForbiddenTimes(PrayerTimesData prayerTimes) {
  final sunriseMin = _parseToMinutes(prayerTimes.sunrise);
  final dhuhrMin = _parseToMinutes(prayerTimes.dhuhr);
  final maghribMin = _parseToMinutes(prayerTimes.maghrib);

  return [
    ForbiddenTime(
      label: 'সূর্যোদয়',
      start: _formatMinutes(sunriseMin),
      end: _formatMinutes(sunriseMin + 14),
    ),
    ForbiddenTime(
      label: 'দুপুর (ইসতিওয়া)',
      start: _formatMinutes(dhuhrMin - 6),
      end: _formatMinutes(dhuhrMin),
    ),
    // সূর্যাস্তের ঠিক আগের সময়টাও নামাজের জন্য নিষিদ্ধ — সূর্য সম্পূর্ণ
    // অস্ত যাওয়ার ১৫ মিনিট আগে থেকে মাগরিবের ওয়াক্ত শুরু পর্যন্ত।
    ForbiddenTime(
      label: 'সূর্যাস্ত',
      start: _formatMinutes(maghribMin - 15),
      end: _formatMinutes(maghribMin),
    ),
  ];
}

// ==========================================================
// বাংলা সংখ্যায় সময়/সংখ্যা দেখানোর জন্য শেয়ার্ড হেল্পার —
// prayer_section.dart আর prayer_arc_card.dart দুটোতেই ব্যবহৃত হয়,
// যাতে দুই জায়গায় একই লজিক আলাদা করে লিখতে না হয়।
// ==========================================================

const _englishDigits = '0123456789';
const _banglaDigits = '০১২৩৪৫৬৭৮৯';

String _digitsToBangla(String input) {
  return input.split('').map((c) {
    final i = _englishDigits.indexOf(c);
    return i == -1 ? c : _banglaDigits[i];
  }).join();
}

/// "6:46 AM" স্টাইলের সময়কে "৬:৪৬" স্টাইলে বদলায় (AM/PM বাদ দিয়ে)।
/// ফরম্যাট না মিললে নিরাপদে শুধু সংখ্যাগুলো বাংলায় বদলে দেয়।
String bnTime(String time) {
  final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(time);
  if (match == null) return _digitsToBangla(time);
  return _digitsToBangla('${match.group(1)}:${match.group(2)}');
}

/// যেকোনো int-কে বাংলা সংখ্যায় দেখায় (যেমন বাকি সময়ের ঘণ্টা/মিনিট)।
String bnNum(int number) => _digitsToBangla(number.toString());

/// আজ শুক্রবার কিনা — যোহর/জুম'আ লেবেল বদলাতে ব্যবহৃত হয়।
bool get isJumuahDay => DateTime.now().weekday == DateTime.friday;
