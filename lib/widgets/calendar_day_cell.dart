import 'package:flutter/material.dart';
import '../models/meal_record.dart';

class CalendarDayCell extends StatelessWidget {
  final int dayNumber;
  final String dateKey;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final MealDayRecord? record;
  final VoidCallback onTap;

  const CalendarDayCell({
    super.key,
    required this.dayNumber,
    required this.dateKey,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    this.record,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final morningTaken = record?.morning ?? false;
    final nightTaken = record?.night ?? false;

    Color backgroundColor;
    Border? border;

    if (isSelected) {
      backgroundColor = const Color(0xFFECFDF5); // Emerald-50
      border = Border.all(color: const Color(0xFF059669), width: 2); // Emerald-600
    } else if (isToday) {
      backgroundColor = const Color(0xFFFFFBEB); // Amber-50
      border = Border.all(color: const Color(0xFFFCD34D), width: 1.5); // Amber-300
    } else if (isCurrentMonth) {
      backgroundColor = Colors.white;
      border = Border.all(color: const Color(0xFFE7E5E4), width: 1); // Stone-200
    } else {
      backgroundColor = const Color(0xFFFAFAF9); // Stone-50
      border = Border.all(color: const Color(0xFFF5F5F4), width: 1);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: border,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF065F46)
                        : isToday
                            ? const Color(0xFF92400E)
                            : isCurrentMonth
                                ? const Color(0xFF1C1917)
                                : const Color(0xFFA8A29E),
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Today',
                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Morning indicator
                _buildMealIndicator(morningTaken, isCurrentMonth),
                const SizedBox(width: 4),
                // Night indicator
                _buildMealIndicator(nightTaken, isCurrentMonth),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealIndicator(bool isTaken, bool isCurrent) {
    if (isTaken) {
      return Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981), // Emerald-500
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.check, size: 12, color: Colors.white),
      );
    }
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFFF5F5F4) : const Color(0xFFFAFAF9),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: const Icon(Icons.remove, size: 10, color: Color(0xFFA8A29E)),
    );
  }
}
