import 'package:flutter/material.dart';
import '../models/meal_record.dart';
import '../services/storage_service.dart';
import '../services/stats_service.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/daily_tracker_card.dart';
import '../widgets/monthly_summary_card.dart';
import '../widgets/yearly_summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // 0=Calendar, 1=Statistics
  Map<String, MealDayRecord> _records = {};
  bool _isLoading = true;

  late int _currentYear;
  late int _currentMonth; // 1-12
  late String _selectedDateKey;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentYear = now.year;
    _currentMonth = now.month;
    _selectedDateKey = StatsService.formatDateKey(now);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await StorageService.loadRecords();
    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  Future<void> _updateMeal(String dateKey, String mealType, bool status) async {
    final existing = _records[dateKey] ?? const MealDayRecord();
    final updatedRecord = mealType == 'morning'
        ? existing.copyWith(morning: status)
        : existing.copyWith(night: status);

    final updatedMap = Map<String, MealDayRecord>.from(_records);
    updatedMap[dateKey] = updatedRecord;

    setState(() => _records = updatedMap);
    await StorageService.saveRecords(updatedMap);
  }

  Future<void> _markBoth(String dateKey, bool status) async {
    final updatedRecord = MealDayRecord(morning: status, night: status);
    final updatedMap = Map<String, MealDayRecord>.from(_records);
    updatedMap[dateKey] = updatedRecord;

    setState(() => _records = updatedMap);
    await StorageService.saveRecords(updatedMap);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(status ? 'Both meals marked as taken!' : 'Meals marked as not taken'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _resetDay(String dateKey) async {
    final updatedMap = Map<String, MealDayRecord>.from(_records);
    updatedMap.remove(dateKey);

    setState(() => _records = updatedMap);
    await StorageService.saveRecords(updatedMap);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Day meal status reset'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onSelectDate(String dateKey) {
    setState(() {
      _selectedDateKey = dateKey;
      final parts = dateKey.split('-').map(int.parse).toList();
      _currentYear = parts[0];
      _currentMonth = parts[1];
    });
  }

  void _onPrevMonth() {
    setState(() {
      if (_currentMonth == 1) {
        _currentMonth = 12;
        _currentYear--;
      } else {
        _currentMonth--;
      }
    });
  }

  void _onNextMonth() {
    setState(() {
      if (_currentMonth == 12) {
        _currentMonth = 1;
        _currentYear++;
      } else {
        _currentMonth++;
      }
    });
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _currentYear = now.year;
      _currentMonth = now.month;
      _selectedDateKey = StatsService.formatDateKey(now);
    });
  }

  Future<void> _confirmClearAll() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all meal records?'),
        content: const Text(
          'This will permanently delete all logged morning and night meal records. Your statistics will reset to zero.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFE11D48)),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (result == true) {
      await StorageService.clearAll();
      setState(() => _records = {});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All meal records cleared')),
        );
      }
    }
  }

  Future<void> _loadSampleData() async {
    final sample = StorageService.generateSampleData();
    await StorageService.saveRecords(sample);
    setState(() => _records = sample);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sample demo data loaded')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final monthlyStats = StatsService.calculateMonthlyStats(_records, _currentYear, _currentMonth);
    final yearlyStats = StatsService.calculateYearlyStats(_records, _currentYear);
    final streak = StatsService.calculateStreak(_records);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F4), // Stone-100
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF059669),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meal Tracker',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1C1917),
                  ),
                ),
                Text(
                  'Track your meals. See your progress.',
                  style: TextStyle(fontSize: 10, color: Color(0xFF78716C)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF44403C)),
            onSelected: (val) {
              if (val == 'sample') _loadSampleData();
              if (val == 'clear') _confirmClearAll();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(
                value: 'sample',
                child: Row(
                  children: [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text('Load Sample Data'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All Records', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _currentIndex == 0
          ? _buildCalendarView(monthlyStats)
          : _buildStatisticsView(monthlyStats, yearlyStats, streak),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFD1FAE5),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: Color(0xFF059669)),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: Color(0xFF059669)),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(MonthlyStats monthlyStats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          CalendarWidget(
            currentYear: _currentYear,
            currentMonth: _currentMonth,
            selectedDateKey: _selectedDateKey,
            records: _records,
            onSelectDate: _onSelectDate,
            onPrevMonth: _onPrevMonth,
            onNextMonth: _onNextMonth,
            onGoToToday: _goToToday,
          ),
          const SizedBox(height: 14),
          DailyTrackerCard(
            selectedDateKey: _selectedDateKey,
            record: _records[_selectedDateKey],
            onUpdateMeal: _updateMeal,
            onResetDay: _resetDay,
            onMarkBoth: _markBoth,
          ),
          const SizedBox(height: 14),
          MonthlySummaryCard(
            stats: monthlyStats,
            month: _currentMonth,
            year: _currentYear,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsView(MonthlyStats monthlyStats, YearlyStats yearlyStats, Map<String, int> streak) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Streak Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE7E5E4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_fire_department_rounded, color: Color(0xFFEA580C), size: 28),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CURRENT STREAK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFA8A29E))),
                    Text('${streak['current'] ?? 0} Days', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF1C1917))),
                    Text('Best streak: ${streak['best'] ?? 0} days', style: const TextStyle(fontSize: 11, color: Color(0xFF78716C))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          MonthlySummaryCard(
            stats: monthlyStats,
            month: _currentMonth,
            year: _currentYear,
          ),
          const SizedBox(height: 14),

          YearlySummaryCard(
            stats: yearlyStats,
            selectedYear: _currentYear,
            onPrevYear: () => setState(() => _currentYear--),
            onNextYear: () => setState(() => _currentYear++),
            onSelectMonth: (m) {
              setState(() {
                _currentMonth = m;
                _currentIndex = 0; // jump to calendar
              });
            },
          ),
        ],
      ),
    );
  }
}
