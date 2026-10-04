import 'package:intl/intl.dart';
import '../models/meal_record.dart';

class StatsService {
  static const List<String> monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  static String formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formatKey(int year, int month, int day) {
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$year-$m-$d';
  }

  static int getDaysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static MonthlyStats calculateMonthlyStats(
    Map<String, MealDayRecord> records,
    int year,
    int month, // 1 - 12
  ) {
    final daysInMonth = getDaysInMonth(year, month);
    int morningCount = 0;
    int nightCount = 0;
    int completeDays = 0;
    int trackedDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final key = formatKey(year, month, day);
      final record = records[key];

      if (record != null) {
        if (record.morning) morningCount++;
        if (record.night) nightCount++;
        if (record.isComplete) completeDays++;
        if (record.hasAnyMeal) trackedDays++;
      }
    }

    final totalMeals = morningCount + nightCount;
    final completionRate = daysInMonth > 0
        ? ((completeDays / daysInMonth) * 100).round()
        : 0;

    return MonthlyStats(
      morningCount: morningCount,
      nightCount: nightCount,
      totalMeals: totalMeals,
      completeDays: completeDays,
      daysInMonth: daysInMonth,
      trackedDays: trackedDays,
      completionRate: completionRate,
    );
  }

  static YearlyStats calculateYearlyStats(
    Map<String, MealDayRecord> records,
    int year,
  ) {
    int morningCount = 0;
    int nightCount = 0;
    int completeDays = 0;
    final Set<String> trackedDaysSet = {};
    final List<MonthBreakdownItem> breakdown = [];

    for (int month = 1; month <= 12; month++) {
      final daysInMonth = getDaysInMonth(year, month);
      int monthMorning = 0;
      int monthNight = 0;
      int monthComplete = 0;

      for (int day = 1; day <= daysInMonth; day++) {
        final key = formatKey(year, month, day);
        final record = records[key];

        if (record != null) {
          if (record.morning) {
            monthMorning++;
            morningCount++;
          }
          if (record.night) {
            monthNight++;
            nightCount++;
          }
          if (record.isComplete) {
            monthComplete++;
            completeDays++;
          }
          if (record.hasAnyMeal) {
            trackedDaysSet.add(key);
          }
        }
      }

      breakdown.add(MonthBreakdownItem(
        monthIndex: month - 1,
        monthName: monthNames[month - 1],
        morningCount: monthMorning,
        nightCount: monthNight,
        totalMeals: monthMorning + monthNight,
        completeDays: monthComplete,
        daysInMonth: daysInMonth,
      ));
    }

    return YearlyStats(
      year: year,
      morningCount: morningCount,
      nightCount: nightCount,
      totalMeals: morningCount + nightCount,
      trackedDays: trackedDaysSet.length,
      completeDays: completeDays,
      monthlyBreakdown: breakdown,
    );
  }

  static Map<String, int> calculateStreak(Map<String, MealDayRecord> records) {
    final now = DateTime.now();
    final todayKey = formatDateKey(now);
    final sortedKeys = records.keys.toList()..sort();

    int bestStreak = 0;
    int tempStreak = 0;

    for (final key in sortedKeys) {
      final r = records[key];
      if (r != null && r.isComplete) {
        tempStreak++;
        if (tempStreak > bestStreak) bestStreak = tempStreak;
      } else {
        tempStreak = 0;
      }
    }

    int currentStreak = 0;
    DateTime checkDate = now;
    final todayRecord = records[todayKey];

    if (todayRecord != null && todayRecord.isComplete) {
      currentStreak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      final yesterday = now.subtract(const Duration(days: 1));
      final yRecord = records[formatDateKey(yesterday)];
      if (yRecord != null && yRecord.isComplete) {
        checkDate = yesterday;
      } else {
        return {'current': 0, 'best': bestStreak};
      }
    }

    while (true) {
      final key = formatDateKey(checkDate);
      final rec = records[key];
      if (rec != null && rec.isComplete) {
        if (key != todayKey) currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return {
      'current': currentStreak,
      'best': bestStreak > currentStreak ? bestStreak : currentStreak,
    };
  }
}
