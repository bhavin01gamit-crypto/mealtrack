import 'package:flutter/material.dart';
import '../models/meal_record.dart';

class YearlySummaryCard extends StatelessWidget {
  final YearlyStats stats;
  final int selectedYear;
  final VoidCallback onPrevYear;
  final VoidCallback onNextYear;
  final ValueChanged<int>? onSelectMonth;

  const YearlySummaryCard({
    super.key,
    required this.stats,
    required this.selectedYear,
    required this.onPrevYear,
    required this.onNextYear,
    this.onSelectMonth,
  });

  @override
  Widget build(BuildContext context) {
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
          // Header with Year Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YEARLY SUMMARY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Color(0xFFA8A29E),
                    ),
                  ),
                  Text(
                    'Year $selectedYear',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20),
                    onPressed: onPrevYear,
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFF5F5F4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '$selectedYear',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20),
                    onPressed: onNextYear,
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

          // 4 Yearly Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildTile('Morning', stats.morningCount, Icons.wb_sunny_rounded, const Color(0xFFD97706)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTile('Night', stats.nightCount, Icons.nightlight_round, const Color(0xFF4F46E5)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildTile('Total Meals', stats.totalMeals, Icons.restaurant_rounded, const Color(0xFF44403C)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTile('Tracked Days', stats.trackedDays, Icons.calendar_today_rounded, const Color(0xFF059669),
                    subtitle: '${stats.completeDays} complete'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            '12-MONTH OVERVIEW',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Color(0xFFA8A29E),
            ),
          ),
          const SizedBox(height: 8),

          // 12-Month mini breakdown
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stats.monthlyBreakdown.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.6,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              final m = stats.monthlyBreakdown[index];
              return InkWell(
                onTap: onSelectMonth != null ? () => onSelectMonth!(m.monthIndex + 1) : null,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAF9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE7E5E4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            m.monthName.substring(0, 3),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${m.totalMeals}m',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Text('🌅 ${m.morningCount}', style: const TextStyle(fontSize: 9, color: Color(0xFF78716C))),
                          const SizedBox(width: 4),
                          Text('🌙 ${m.nightCount}', style: const TextStyle(fontSize: 9, color: Color(0xFF78716C))),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTile(String title, int count, IconData icon, Color color, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7E5E4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF78716C)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$count',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1C1917)),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Color(0xFF059669), fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}
