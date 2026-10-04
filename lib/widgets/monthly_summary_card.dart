import 'package:flutter/material.dart';
import '../models/meal_record.dart';
import '../services/stats_service.dart';

class MonthlySummaryCard extends StatelessWidget {
  final MonthlyStats stats;
  final int month; // 1-12
  final int year;

  const MonthlySummaryCard({
    super.key,
    required this.stats,
    required this.month,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final monthName = StatsService.monthNames[month - 1];
    final maxPossible = stats.daysInMonth * 2;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MONTHLY SUMMARY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color(0xFFA8A29E),
                    ),
                  ),
                  Text(
                    '$monthName $year',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Text(
                  '${stats.completionRate}% complete',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 4 Metric Grid
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Morning',
                  value: stats.morningCount,
                  total: stats.daysInMonth,
                  color: const Color(0xFFD97706),
                  bgColor: const Color(0xFFFEF3C7),
                  icon: Icons.wb_sunny_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Night',
                  value: stats.nightCount,
                  total: stats.daysInMonth,
                  color: const Color(0xFF4F46E5),
                  bgColor: const Color(0xFFE0E7FF),
                  icon: Icons.nightlight_round,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  label: 'Total Meals',
                  value: stats.totalMeals,
                  total: maxPossible,
                  color: const Color(0xFF44403C),
                  bgColor: const Color(0xFFF5F5F4),
                  icon: Icons.restaurant_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  label: 'Complete Days',
                  value: stats.completeDays,
                  total: stats.daysInMonth,
                  color: const Color(0xFF059669),
                  bgColor: const Color(0xFFD1FAE5),
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Progress Ratio Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: stats.morningCount,
                    child: Container(color: const Color(0xFFFBBF24)),
                  ),
                  Expanded(
                    flex: stats.nightCount,
                    child: Container(color: const Color(0xFF6366F1)),
                  ),
                  Expanded(
                    flex: (maxPossible - stats.totalMeals).clamp(0, maxPossible),
                    child: Container(color: const Color(0xFFE7E5E4)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🌅 Morning: ${stats.morningCount} · 🌙 Night: ${stats.nightCount}',
                style: const TextStyle(fontSize: 10, color: Color(0xFF78716C)),
              ),
              Text(
                '${stats.trackedDays} days tracked',
                style: const TextStyle(fontSize: 10, color: Color(0xFF78716C)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required int value,
    required int total,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$value',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1C1917),
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '/$total',
                style: const TextStyle(fontSize: 11, color: Color(0xFF78716C)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
