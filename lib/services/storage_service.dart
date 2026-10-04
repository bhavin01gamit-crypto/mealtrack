import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_record.dart';
import 'stats_service.dart';

class StorageService {
  static const String _storageKey = 'meal_tracker_records_v1';
  static const String _initializedKey = 'meal_tracker_has_initialized_v1';

  static Future<Map<String, MealDayRecord>> loadRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    final hasInit = prefs.getBool(_initializedKey) ?? false;

    if (raw != null && raw.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(raw);
        return decoded.map((key, value) =>
            MapEntry(key, MealDayRecord.fromJson(Map<String, dynamic>.from(value))));
      } catch (e) {
        // Fallback
      }
    }

    if (!hasInit) {
      final sample = generateSampleData();
      await saveRecords(sample);
      await prefs.setBool(_initializedKey, true);
      return sample;
    }

    return {};
  }

  static Future<void> saveRecords(Map<String, MealDayRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> encodable =
        records.map((key, value) => MapEntry(key, value.toJson()));
    await prefs.setString(_storageKey, jsonEncode(encodable));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    await prefs.setBool(_initializedKey, true);
  }

  static Map<String, MealDayRecord> generateSampleData() {
    final Map<String, MealDayRecord> records = {};
    final currentYear = DateTime.now().year;

    final configs = [
      {'month': 7, 'days': 31},
      {'month': 8, 'days': 31},
      {'month': 9, 'days': 30},
      {'month': 10, 'days': 1},
    ];

    for (final cfg in configs) {
      final month = cfg['month'] as int;
      final days = cfg['days'] as int;
      for (int day = 1; day <= days; day++) {
        final key = StatsService.formatKey(currentYear, month, day);
        final hash = (day * 17 + month * 31) % 100;
        final morning = hash > 15;
        final night = hash > 22;
        records[key] = MealDayRecord(morning: morning, night: night);
      }
    }

    // Default today's date
    final todayKey = StatsService.formatDateKey(DateTime.now());
    records[todayKey] = const MealDayRecord(morning: true, night: false);

    return records;
  }
}
