import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/meal_record.dart';

class DailyTrackerCard extends StatelessWidget {
  final String selectedDateKey;
  final MealDayRecord? record;
  final Function(String dateKey, String mealType, bool status) onUpdateMeal;
  final ValueChanged<String> onResetDay;
  final Function(String dateKey, bool status) onMarkBoth;

  const DailyTrackerCard({
    super.key,
    required this.selectedDateKey,
    this.record,
    required this.onUpdateMeal,
    required this.onResetDay,
    required this.onMarkBoth,
  });

  @override
  Widget build(BuildContext context) {
    final morningTaken = record?.morning ?? false;
    final nightTaken = record?.night ?? false;
    final isComplete = morningTaken && nightTaken;

    DateTime date;
    try {
      date = DateFormat('yyyy-MM-dd').parse(selectedDateKey);
    } catch (_) {
      date = DateTime.now();
    }
    final formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(date);

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
          // Header: Date & Status Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SELECTED DATE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                        color: Color(0xFFA8A29E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1C1917),
                      ),
                    ),
                  ],
                ),
              ),
              if (isComplete)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, size: 12, color: Color(0xFF059669)),
                      SizedBox(width: 4),
                      Text(
                        'Complete Day',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Morning Meal Card
          _buildMealSection(
            title: 'Morning Meal',
            subtitle: 'Breakfast / morning intake',
            icon: Icons.wb_sunny_rounded,
            iconColor: const Color(0xFFD97706),
            iconBg: const Color(0xFFFEF3C7),
            isTaken: morningTaken,
            onTaken: () => onUpdateMeal(selectedDateKey, 'morning', true),
            onNotTaken: () => onUpdateMeal(selectedDateKey, 'morning', false),
          ),
          const SizedBox(height: 10),

          // Night Meal Card
          _buildMealSection(
            title: 'Night Meal',
            subtitle: 'Dinner / night intake',
            icon: Icons.nightlight_round,
            iconColor: const Color(0xFF4F46E5),
            iconBg: const Color(0xFFE0E7FF),
            isTaken: nightTaken,
            onTaken: () => onUpdateMeal(selectedDateKey, 'night', true),
            onNotTaken: () => onUpdateMeal(selectedDateKey, 'night', false),
          ),
          const SizedBox(height: 14),

          // Quick Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => onMarkBoth(selectedDateKey, true),
                    icon: const Icon(Icons.done_all, size: 14),
                    label: const Text('Both Taken', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      minimumSize: const Size(0, 36),
                      foregroundColor: const Color(0xFF059669),
                      side: const BorderSide(color: Color(0xFFA7F3D0)),
                      backgroundColor: const Color(0xFFECFDF5),
                    ),
                  ),
                  const SizedBox(width: 6),
                  OutlinedButton(
                    onPressed: () => onMarkBoth(selectedDateKey, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      minimumSize: const Size(0, 36),
                      foregroundColor: const Color(0xFF78716C),
                      side: const BorderSide(color: Color(0xFFE7E5E4)),
                    ),
                    child: const Text('Mark None', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () => onResetDay(selectedDateKey),
                icon: const Icon(Icons.refresh, size: 14),
                label: const Text('Reset', style: TextStyle(fontSize: 11)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                  minimumSize: const Size(0, 36),
                  foregroundColor: const Color(0xFFE11D48),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required bool isTaken,
    required VoidCallback onTaken,
    required VoidCallback onNotTaken,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isTaken ? const Color(0xFFF0FDF4) : const Color(0xFFFAFAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isTaken ? const Color(0xFF86EFAC) : const Color(0xFFE7E5E4),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF78716C)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: onTaken,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Taken', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTaken ? const Color(0xFF059669) : Colors.white,
                      foregroundColor: isTaken ? Colors.white : const Color(0xFF44403C),
                      elevation: isTaken ? 1 : 0,
                      side: BorderSide(
                        color: isTaken ? const Color(0xFF059669) : const Color(0xFFD6D3D1),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: onNotTaken,
                    icon: const Icon(Icons.radio_button_unchecked, size: 14),
                    label: const Text('Not Taken', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isTaken ? const Color(0xFF292524) : Colors.white,
                      foregroundColor: !isTaken ? Colors.white : const Color(0xFF78716C),
                      elevation: !isTaken ? 1 : 0,
                      side: BorderSide(
                        color: !isTaken ? const Color(0xFF292524) : const Color(0xFFD6D3D1),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
