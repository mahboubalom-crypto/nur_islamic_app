import 'dart:math' as math;

// ==========================================================
// Prayer Times Data
// ==========================================================
class PrayerTimesData {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String asrHanafi;
  final String maghrib;
  final String isha;

  PrayerTimesData({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.asrHanafi,
    required this.maghrib,
    required this.isha,
  });
}

// ==========================================================
// Next Prayer
// ==========================================================
class NextPrayerInfo {
  final String nameBangla;
  final String nameEnglish;
  final String timeString;
  final int remainingSeconds;

  NextPrayerInfo({
    required this.nameBangla,
    required this.nameEnglish,
    required this.timeString,
    required this.remainingSeconds,
  });
}

// ==========================================================
// Current Prayer
// ==========================================================
class CurrentPrayerInfo {
  final String nameBangla;
  final String nameEnglish;
  final String startTime;
  final String nextTime;
  final int elapsedSeconds;
  final int totalSeconds;
  final int remainingSeconds;

  CurrentPrayerInfo({
    required this.nameBangla,
    required this.nameEnglish,
    required this.startTime,
    required this.nextTime,
    required this.elapsedSeconds,
    required this.totalSeconds,
    required this.remainingSeconds,
  });
}

// ==========================================================
// Prayer Time Calculation
// ==========================================================
PrayerTimesData calculatePrayerTimes(
  double lat,
  double lng, {
  DateTime? date,
  String method = 'IslamicFoundation',
}) {
  final d = date ?? DateTime.now();

  final year = d.year;
  final month = d.month;
  final day = d.day;

  final dNum = 367 * year -
      ((7 * (year + ((month + 9) / 12).floor())) / 4).floor() +
      ((275 * month) / 9).floor() +
      day -
      730531.5;

  final l = _fixAngle(280.461 + 0.9856474 * dNum);
  final m = _fixAngle(357.528 + 0.9856003 * dNum);

  final lambda = _fixAngle(
    l + 1.915 * _sin(m) + 0.02 * _sin(2 * m),
  );

  final obliq = 23.439 - 0.0000004 * dNum;

  final alpha = _fixAngle(
    _toDegrees(
      math.atan2(
        _cos(obliq) * _sin(lambda),
        _cos(lambda),
      ),
    ),
  );

  final declination = _toDegrees(
    math.asin(
      _sin(obliq) * _sin(lambda),
    ),
  );

  // Equation of time
  double equationOfTime = (l - alpha) / 15;

  if (equationOfTime > 12) {
    equationOfTime -= 24;
  }

  if (equationOfTime < -12) {
    equationOfTime += 24;
  }

  // ========================================================
  // Timezone
  //
  // GPS-selected location সাধারণত ডিভাইসের বর্তমান timezone-এর
  // সাথে ব্যবহার করা হচ্ছে। তাই ডিভাইসের timezone ব্যবহার করা হবে।
  //
  // যদি ডিভাইস timezone পাওয়া না যায়, longitude থেকে fallback হবে।
  // ========================================================
  final localOffsetHours = DateTime.now().timeZoneOffset.inMinutes / 60.0;

  final longitudeTimezone = (lng / 15).roundToDouble();

  final timezoneOffset =
      localOffsetHours.abs() <= 14 ? localOffsetHours : longitudeTimezone;

  final solarNoon = 12 + timezoneOffset - (lng / 15) - equationOfTime;

  // ========================================================
  // Calculation Method
  // ========================================================
  double fajrAngle = 18;
  double ishaAngle = 18;

  switch (method) {
    case 'MWL':
      fajrAngle = 18;
      ishaAngle = 17;
      break;

    case 'ISNA':
      fajrAngle = 15;
      ishaAngle = 15;
      break;

    case 'Karachi':
      fajrAngle = 18;
      ishaAngle = 18;
      break;

    case 'UmmAlQura':
      fajrAngle = 18.5;
      ishaAngle = 19;
      break;

    case 'IslamicFoundation':
    default:
      fajrAngle = 18;
      ishaAngle = 18;
      break;
  }

  // ========================================================
  // Fajr
  // ========================================================
  final fajrHourAngle = _sunAngleHour(fajrAngle, lat, declination);

  final fajrTime = solarNoon - fajrHourAngle / 15;

  // ========================================================
  // Sunrise
  // ========================================================
  final sunriseHourAngle = _sunAngleHour(0.833, lat, declination);

  final sunriseTime = solarNoon - sunriseHourAngle / 15;

  // ========================================================
  // Dhuhr
  // ========================================================
  final dhuhrTime = solarNoon + 0.033;

  // ========================================================
  // Asr Standard
  // Shadow factor = 1
  // ========================================================
  final asrTime = _calculateAsrTime(
    lat,
    declination,
    solarNoon,
    1,
  );

  // ========================================================
  // Asr Hanafi
  // Shadow factor = 2
  // ========================================================
  final asrHanafiTime = _calculateAsrTime(
    lat,
    declination,
    solarNoon,
    2,
  );

  // ========================================================
  // Maghrib
  // ========================================================
  final maghribTime = solarNoon + sunriseHourAngle / 15 + 0.033;

  // ========================================================
  // Isha
  // ========================================================
  final ishaHourAngle = _sunAngleHour(ishaAngle, lat, declination);

  final ishaTime = solarNoon + ishaHourAngle / 15;

  return PrayerTimesData(
    fajr: _formatDecimalHours(fajrTime),
    sunrise: _formatDecimalHours(sunriseTime),
    dhuhr: _formatDecimalHours(dhuhrTime),
    asr: _formatDecimalHours(asrTime),
    asrHanafi: _formatDecimalHours(asrHanafiTime),
    maghrib: _formatDecimalHours(maghribTime),
    isha: _formatDecimalHours(ishaTime),
  );
}

// ==========================================================
// Asr Calculation
// ==========================================================
double _calculateAsrTime(
  double lat,
  double declination,
  double solarNoon,
  int shadowFactor,
) {
  final angle = _toDegrees(
    math.atan(
      1 /
          (shadowFactor +
              math.tan(
                _toRadians(
                  (lat - declination).abs(),
                ),
              )),
    ),
  );

  final cosH = (_sin(angle) - _sin(lat) * _sin(declination)) /
      (_cos(lat) * _cos(declination));

  final hourAngle = _toDegrees(
    math.acos(
      cosH.clamp(-1.0, 1.0),
    ),
  );

  return solarNoon + hourAngle / 15;
}

// ==========================================================
// Sun Angle
// ==========================================================
double _sunAngleHour(
  double angle,
  double lat,
  double declination,
) {
  final cosH = (-_sin(angle) - _sin(lat) * _sin(declination)) /
      (_cos(lat) * _cos(declination));

  if (cosH > 1) {
    return 0;
  }

  if (cosH < -1) {
    return 180;
  }

  return _toDegrees(
    math.acos(cosH),
  );
}

// ==========================================================
// Helpers
// ==========================================================
double _fixAngle(double value) {
  value = value - 360 * (value / 360).floor();

  return value < 0 ? value + 360 : value;
}

double _sin(double deg) {
  return math.sin(_toRadians(deg));
}

double _cos(double deg) {
  return math.cos(_toRadians(deg));
}

double _toRadians(double deg) {
  return deg * math.pi / 180;
}

double _toDegrees(double rad) {
  return rad * 180 / math.pi;
}

// ==========================================================
// Decimal Hours -> 12 Hour Format
// ==========================================================
String _formatDecimalHours(double decimalHours) {
  decimalHours %= 24;

  if (decimalHours < 0) {
    decimalHours += 24;
  }

  int hours = decimalHours.floor();

  int minutes = ((decimalHours - hours) * 60).round();

  if (minutes >= 60) {
    hours++;
    minutes = 0;
  }

  hours %= 24;

  final period = hours >= 12 ? 'PM' : 'AM';

  final displayHours = hours % 12 == 0 ? 12 : hours % 12;

  final minutesStr = minutes.toString().padLeft(2, '0');

  return '$displayHours:$minutesStr $period';
}

// ==========================================================
// Time String -> Minutes
// ==========================================================
int prayerTimeToMinutes(String timeString) {
  final parts = timeString.trim().split(' ');

  if (parts.length < 2) {
    return 0;
  }

  final hm = parts[0].split(':');

  int hour = int.tryParse(hm[0]) ?? 0;
  final minute = int.tryParse(hm[1]) ?? 0;

  final period = parts[1].toUpperCase();

  if (period == 'PM' && hour != 12) {
    hour += 12;
  }

  if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  return hour * 60 + minute;
}

// ==========================================================
// Next Prayer
// ==========================================================
NextPrayerInfo getNextPrayerInfo(
  PrayerTimesData prayerTimes,
) {
  final now = DateTime.now();

  final currentSeconds = now.hour * 3600 + now.minute * 60 + now.second;

  final prayers = [
    {
      'nameBangla': 'ফজর',
      'nameEnglish': 'Fajr',
      'time': prayerTimes.fajr,
    },
    {
      'nameBangla': 'যোহর',
      'nameEnglish': 'Dhuhr',
      'time': prayerTimes.dhuhr,
    },
    {
      'nameBangla': 'আসর',
      'nameEnglish': 'Asr',
      'time': prayerTimes.asr,
    },
    {
      'nameBangla': 'মাগরিব',
      'nameEnglish': 'Maghrib',
      'time': prayerTimes.maghrib,
    },
    {
      'nameBangla': 'এশা',
      'nameEnglish': 'Isha',
      'time': prayerTimes.isha,
    },
  ];

  for (final prayer in prayers) {
    final time = prayer['time'] as String;

    final minutes = prayerTimeToMinutes(time);

    final prayerSeconds = minutes * 60;

    if (prayerSeconds > currentSeconds) {
      return NextPrayerInfo(
        nameBangla: prayer['nameBangla'] as String,
        nameEnglish: prayer['nameEnglish'] as String,
        timeString: time,
        remainingSeconds: prayerSeconds - currentSeconds,
      );
    }
  }

  // এশার পর -> আগামীকালের ফজর
  final fajrSeconds = prayerTimeToMinutes(prayerTimes.fajr) * 60;

  final tomorrowRemaining = (24 * 60 * 60 - currentSeconds) + fajrSeconds;

  return NextPrayerInfo(
    nameBangla: 'ফজর',
    nameEnglish: 'Fajr',
    timeString: prayerTimes.fajr,
    remainingSeconds: tomorrowRemaining,
  );
}

// ==========================================================
// Current Prayer
// ==========================================================
CurrentPrayerInfo getCurrentPrayerInfo(
  PrayerTimesData prayerTimes,
) {
  final now = DateTime.now();

  final nowSeconds = now.hour * 3600 + now.minute * 60 + now.second;

  final prayers = [
    {
      'nameBangla': 'ফজর',
      'nameEnglish': 'Fajr',
      'time': prayerTimes.fajr,
    },
    {
      'nameBangla': 'যোহর',
      'nameEnglish': 'Dhuhr',
      'time': prayerTimes.dhuhr,
    },
    {
      'nameBangla': 'আসর',
      'nameEnglish': 'Asr',
      'time': prayerTimes.asr,
    },
    {
      'nameBangla': 'মাগরিব',
      'nameEnglish': 'Maghrib',
      'time': prayerTimes.maghrib,
    },
    {
      'nameBangla': 'এশা',
      'nameEnglish': 'Isha',
      'time': prayerTimes.isha,
    },
  ];

  for (int i = 0; i < prayers.length; i++) {
    final current = prayers[i];

    final currentMinutes = prayerTimeToMinutes(
      current['time'] as String,
    );

    final currentSeconds = currentMinutes * 60;

    final next = i + 1 < prayers.length ? prayers[i + 1] : prayers[0];

    int nextSeconds;

    if (i + 1 < prayers.length) {
      nextSeconds = prayerTimeToMinutes(
            next['time'] as String,
          ) *
          60;
    } else {
      nextSeconds = 24 * 60 * 60 +
          prayerTimeToMinutes(
                next['time'] as String,
              ) *
              60;
    }

    int adjustedNow = nowSeconds;

    if (i == prayers.length - 1 && adjustedNow < currentSeconds) {
      adjustedNow += 24 * 60 * 60;
    }

    if (adjustedNow >= currentSeconds && adjustedNow < nextSeconds) {
      final elapsed = adjustedNow - currentSeconds;

      final total = nextSeconds - currentSeconds;

      final remaining = total - elapsed;

      return CurrentPrayerInfo(
        nameBangla: current['nameBangla'] as String,
        nameEnglish: current['nameEnglish'] as String,
        startTime: current['time'] as String,
        nextTime: next['time'] as String,
        elapsedSeconds: elapsed,
        totalSeconds: total,
        remainingSeconds: remaining,
      );
    }
  }

  // মধ্যরাত থেকে ফজরের আগ পর্যন্ত
  final fajrSeconds = prayerTimeToMinutes(prayerTimes.fajr) * 60;

  final adjustedFajr = fajrSeconds;

  final adjustedNow =
      nowSeconds < adjustedFajr ? nowSeconds : nowSeconds - 24 * 60 * 60;

  final total = adjustedFajr +
      24 * 60 * 60 -
      prayerTimeToMinutes(
            prayerTimes.isha,
          ) *
          60;

  final elapsed = adjustedNow -
      (prayerTimeToMinutes(
                prayerTimes.isha,
              ) *
              60 -
          24 * 60 * 60);

  return CurrentPrayerInfo(
    nameBangla: 'এশা',
    nameEnglish: 'Isha',
    startTime: prayerTimes.isha,
    nextTime: prayerTimes.fajr,
    elapsedSeconds: elapsed.clamp(0, total),
    totalSeconds: total,
    remainingSeconds: (total - elapsed).clamp(0, total),
  );
}
