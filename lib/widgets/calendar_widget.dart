import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meal_record.dart';
import '../services/stats_service.dart';
import 'calendar_day_cell.dart';

class CalendarWidget extends StatelessWidget {
  final int currentYear;
  final int currentMonth; // 1-12
  final String selectedDateKey;
  final Map<String, MealDayRecord> records;
  final ValueChanged<String> onSelectDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onGoToToday;

  const CalendarWidget({
    super.key,
    required this.currentYear,
    required this.currentMonth,
    required this.selectedDateKey,
    required this.records,
    required this.onSelectDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onGoToToday,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = StatsService.monthNames[currentMonth - 1];
    final todayKey = StatsService.formatDateKey(DateTime.now());

    final daysInCurrentMonth = StatsService.getDaysInMonth(currentYear, currentMonth);
    final firstWeekday = DateTime(currentYear, currentMonth, 1).weekday % 7; // 0=Sun .. 6=Sat

    // Previous month details
    final prevMonth = currentMonth == 1 ? 12 : currentMonth - 1;
    final prevYear = currentMonth == 1 ? currentYear - 1 : currentYear;
    final daysInPrevMonth = StatsService.getDaysInMonth(prevYear, prevMonth);

    // Build day items
    final List<Map<String, dynamic>> cells = [];

    // Leading days
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = daysInPrevMonth - i;
      final key = StatsService.formatKey(prevYear, prevMonth, day);
      cells.add({
        'day': day,
        'key': key,
        'isCurrent': false,
      });
    }

    // Current days
    for (int day = 1; day <= daysInCurrentMonth; day++) {
      final key = StatsService.formatKey(currentYear, currentMonth, day);
      cells.add({
        'day': day,
        'key': key,
        'isCurrent': true,
      });
    }

    // Trailing days
    final totalSlots = ((cells.length + 6) ~/ 7) * 7;
    final nextMonth = currentMonth == 12 ? 1 : currentMonth + 1;
    final nextYear = currentMonth == 12 ? currentYear + 1 : currentYear;
    final trailingCount = totalSlots - cells.length;

    for (int day = 1; day <= trailingCount; day++) {
      final key = StatsService.formatKey(nextYear, nextMonth, day);
      cells.add({
        'day': day,
        'key': key,
        'isCurrent': false,
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7E5E4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Month, Year, and Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$monthName $currentYear',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  const Text(
                    'Select date to log meals',
                    style: TextStyle(fontSize: 11, color: Color(0xFF78716C)),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: onPrevMonth,
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F4),
                    ),
                  ),
                  const SizedBox(width: 4),
                  FilledButton.tonal(
                    onPressed: onGoToToday,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      minimumSize: const Size(0, 36),
                      backgroundColor: const Color(0xFFF5F5F4),
                      foregroundColor: const Color(0xFF1C1917),
                    ),
                    child: const Text('Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: onNextMonth,
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F4),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Weekday header (Sun - Sat)
          Row(
            children: const ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFA8A29E),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // 7-column Grid of days
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final item = cells[index];
              final dayNumber = item['day'] as int;
              final key = item['key'] as String;
              final isCurrent = item['isCurrent'] as bool;

              return CalendarDayCell(
                dayNumber: dayNumber,
                dateKey: key,
                isCurrentMonth: isCurrent,
                isToday: key == todayKey,
                isSelected: key == selectedDateKey,
                record: records[key],
                onTap: () => onSelectDate(key),
              );
            },
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF5F5F4)),
          const SizedBox(height: 4),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  const Text('Taken', style: TextStyle(fontSize: 11, color: Color(0xFF78716C))),
                  const SizedBox(width: 10),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F4),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFE7E5E4)),
                    ),
                    child: const Icon(Icons.remove, size: 8, color: Color(0xFFA8A29E)),
                  ),
                  const SizedBox(width: 4),
                  const Text('Not Taken', style: TextStyle(fontSize: 11, color: Color(0xFF78716C))),
                ],
              ),
              const Text(
                '🌅 Morning · 🌙 Night',
                style: TextStyle(fontSize: 11, color: Color(0xFFA8A29E)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
