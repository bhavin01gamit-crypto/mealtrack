class MealDayRecord {
  final bool morning;
  final bool night;

  const MealDayRecord({
    this.morning = false,
    this.night = false,
  });

  bool get isComplete => morning && night;
  bool get hasAnyMeal => morning || night;

  MealDayRecord copyWith({
    bool? morning,
    bool? night,
  }) {
    return MealDayRecord(
      morning: morning ?? this.morning,
      night: night ?? this.night,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'morning': morning,
      'night': night,
    };
  }

  factory MealDayRecord.fromJson(Map<String, dynamic> json) {
    return MealDayRecord(
      morning: json['morning'] == true,
      night: json['night'] == true,
    );
  }
}

class MonthlyStats {
  final int morningCount;
  final int nightCount;
  final int totalMeals;
  final int completeDays;
  final int daysInMonth;
  final int trackedDays;
  final int completionRate;

  const MonthlyStats({
    required this.morningCount,
    required this.nightCount,
    required this.totalMeals,
    required this.completeDays,
    required this.daysInMonth,
    required this.trackedDays,
    required this.completionRate,
  });
}

class MonthBreakdownItem {
  final int monthIndex; // 0-11
  final String monthName;
  final int morningCount;
  final int nightCount;
  final int totalMeals;
  final int completeDays;
  final int daysInMonth;

  const MonthBreakdownItem({
    required this.monthIndex,
    required this.monthName,
    required this.morningCount,
    required this.nightCount,
    required this.totalMeals,
    required this.completeDays,
    required this.daysInMonth,
  });
}

class YearlyStats {
  final int year;
  final int morningCount;
  final int nightCount;
  final int totalMeals;
  final int trackedDays;
  final int completeDays;
  final List<MonthBreakdownItem> monthlyBreakdown;

  const YearlyStats({
    required this.year,
    required this.morningCount,
    required this.nightCount,
    required this.totalMeals,
    required this.trackedDays,
    required this.completeDays,
    required this.monthlyBreakdown,
  });
}
