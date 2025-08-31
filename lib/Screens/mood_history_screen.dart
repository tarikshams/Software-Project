// filepath: lib/Screens/mood_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Services/theme_provider.dart';

class MoodHistoryScreen extends ConsumerStatefulWidget {
  const MoodHistoryScreen({super.key});

  @override
  ConsumerState<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends ConsumerState<MoodHistoryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final int _currentStreak = 7;
  DateTime _selectedDate = DateTime.now();

  final List<MoodEntry> _moodData = List.generate(30, (i) {
    final moods = ['😊','😌','😔','😤','😴','🤗','😇','😁'];
    final score = (i % 10) + 1;
    return MoodEntry(
      date: DateTime.now().subtract(Duration(days: 29 - i)),
      mood: moods[i % moods.length],
      score: score,
    );
  });

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Mood History',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.insights_rounded, color: colorScheme.primary),
            onPressed: () {
              // Show insights or analytics
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Streak & Stats
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildStatItem(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: Colors.orange,
                  title: 'Day Streak',
                  value: '$_currentStreak',
                  colorScheme: colorScheme,
                ),
                _buildStatItem(
                  icon: Icons.trending_up_rounded,
                  iconColor: Colors.purple,
                  title: 'Avg Mood',
                  value: '${_calculateAverageMood()}',
                  colorScheme: colorScheme,
                ),
                _buildStatItem(
                  icon: Icons.calendar_today_rounded,
                  iconColor: Colors.blue,
                  title: 'Days Tracked',
                  value: '${_moodData.length}',
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
              indicatorColor: colorScheme.primary,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              tabs: const [
                Tab(text: 'Graph'),
                Tab(text: 'Calendar'),
                Tab(text: 'Badges'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGraphTab(colorScheme),
                _buildCalendarTab(colorScheme),
                _buildBadgesTab(colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          Text(title, style: TextStyle(fontSize: 12, color: colorScheme.onSurface.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildGraphTab(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mood Trend (Last 30 Days)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          const SizedBox(height: 20),
          Expanded(child: _MoodLineChart(moodData: _moodData, colorScheme: colorScheme)),
        ],
      ),
    );
  }

  Widget _buildCalendarTab(ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monthly Calendar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
          const SizedBox(height: 20),
          Expanded(
            child: _MoodCalendar(
              moodData: _moodData,
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                _showMoodDetails(date);
              },
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesTab(ColorScheme colorScheme) {
    final List<Badge> badges = [
      Badge(name: 'First Week', description: 'Tracked mood for 7 days', icon: Icons.star_rounded, color: Colors.yellow, isUnlocked: _moodData.length >= 7),
      Badge(name: 'Streak Master', description: 'Maintained a 7-day streak', icon: Icons.local_fire_department_rounded, color: Colors.orange, isUnlocked: _currentStreak >= 7),
      Badge(name: 'Mood Explorer', description: 'Used all 8 mood options', icon: Icons.emoji_emotions_rounded, color: Colors.purple, isUnlocked: _getUniqueMoods().length >= 8),
      Badge(name: 'Consistent', description: 'Tracked mood for 30 days', icon: Icons.calendar_month_rounded, color: Colors.blue, isUnlocked: _moodData.length >= 30),
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: badges.length,
        itemBuilder: (context, index) {
          final badge = badges[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: badge.isUnlocked ? badge.color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(badge.icon, color: badge.isUnlocked ? badge.color : Colors.grey, size: 25),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(badge.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: badge.isUnlocked ? colorScheme.onSurface : Colors.grey)),
                      Text(badge.description, style: TextStyle(fontSize: 14, color: badge.isUnlocked ? colorScheme.onSurface.withOpacity(0.7) : Colors.grey)),
                    ],
                  ),
                ),
                if (badge.isUnlocked)
                  Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showMoodDetails(DateTime date) {
    final moodEntry = _moodData.firstWhere(
      (entry) => entry.date.day == date.day && entry.date.month == date.month && entry.date.year == date.year,
      orElse: () => MoodEntry(date: date, mood: '❓', score: 0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Mood on ${_formatDate(date)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (moodEntry.score > 0) ...[
              Text(moodEntry.mood, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text('Mood Score: ${moodEntry.score}/10'),
            ] else
              const Text('No mood recorded for this date'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close', style: TextStyle(color: Theme.of(context).colorScheme.primary))),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  double _calculateAverageMood() => _moodData.isEmpty ? 0 : (_moodData.fold(0.0, (sum, entry) => sum + entry.score) / _moodData.length).roundToDouble();
  List<String> _getUniqueMoods() => _moodData.map((e) => e.mood).toSet().toList();
}

// Data classes
class MoodEntry {
  final DateTime date;
  final String mood;
  final int score;
  MoodEntry({required this.date, required this.mood, required this.score});
}

class Badge {
  final String name, description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  Badge({required this.name, required this.description, required this.icon, required this.color, required this.isUnlocked});
}

// Chart Widget
class _MoodLineChart extends StatelessWidget {
  final List<MoodEntry> moodData;
  final ColorScheme colorScheme;
  const _MoodLineChart({required this.moodData, required this.colorScheme});

  @override
  Widget build(BuildContext context) => CustomPaint(size: const Size(double.infinity, double.infinity), painter: MoodLineChartPainter(moodData: moodData, color: colorScheme.primary));
}

class MoodLineChartPainter extends CustomPainter {
  final List<MoodEntry> moodData;
  final Color color;
  MoodLineChartPainter({required this.moodData, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (moodData.isEmpty) return;
    final paint = Paint()..color = color..strokeWidth = 3..style = PaintingStyle.stroke;
    final path = Path();
    final width = size.width;
    final height = size.height;
    const padding = 40.0;

    for (int i = 0; i < moodData.length; i++) {
      final x = padding + (i / (moodData.length - 1)) * (width - 2 * padding);
      final y = height - padding - (moodData[i].score / 10) * (height - 2 * padding);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      final textPainter = TextPainter(text: TextSpan(text: moodData[i].mood, style: const TextStyle(fontSize: 16)), textDirection: TextDirection.ltr);
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height - 10));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Calendar Widget
class _MoodCalendar extends StatelessWidget {
  final List<MoodEntry> moodData;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final ColorScheme colorScheme;

  const _MoodCalendar({required this.moodData, required this.selectedDate, required this.onDateSelected, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDay.day;
    final firstWeekday = firstDay.weekday;

    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.chevron_left_rounded, color: colorScheme.onSurface)),
            Text('${_getMonthName(now.month)} ${now.year}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            IconButton(onPressed: () {}, icon: Icon(Icons.chevron_right_rounded, color: colorScheme.onSurface)),
          ],
        ),
        const SizedBox(height: 12),
        // Weekday headers
        Row(children: ['S','M','T','W','T','F','S'].map((d) => Expanded(child: Text(d, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface.withOpacity(0.7))))).toList()),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1),
            itemCount: 42,
            itemBuilder: (context, index) {
              final dayOffset = index - firstWeekday + 1;
              if (dayOffset < 1 || dayOffset > daysInMonth) return const SizedBox();
              final date = DateTime(now.year, now.month, dayOffset);
              final moodEntry = moodData.firstWhere(
                (e) => e.date.day == dayOffset && e.date.month == now.month && e.date.year == now.year,
                orElse: () => MoodEntry(date: date, mood: '', score: 0),
              );
              final isSelected = selectedDate.day == dayOffset;
              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected ? colorScheme.primary.withOpacity(0.2) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected ? Border.all(color: colorScheme.primary, width: 2) : null,
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('$dayOffset', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
                    if (moodEntry.mood.isNotEmpty) const SizedBox(height: 2),
                    if (moodEntry.mood.isNotEmpty) Text(moodEntry.mood, style: const TextStyle(fontSize: 12)),
                  ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return months[month-1];
  }
}
