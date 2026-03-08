import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../services/habit_service.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String habitId = ModalRoute.of(context)!.settings.arguments as String;
    final habitService = context.watch<HabitService>();
    final habit = habitService.getHabitById(habitId);

    if (habit == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Habit')),
        body: const Center(child: Text('Habit not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, habitService, habit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    title: 'Current Streak',
                    value: '${habit.currentStreak}',
                    subtitle: 'days',
                    icon: Icons.local_fire_department,
                    color: AppTheme.streakColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    title: 'Best Streak',
                    value: '${habit.bestStreak}',
                    subtitle: 'days',
                    icon: Icons.emoji_events,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    title: 'Total Completions',
                    value: '${habit.completions.length}',
                    subtitle: 'times',
                    icon: Icons.check_circle,
                    color: AppTheme.secondaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatTile(
                    title: 'Success Rate',
                    value: '${(habit.getCompletionRate() * 100).toStringAsFixed(0)}%',
                    subtitle: 'completion',
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Completion Calendar
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _CompletionCalendar(habit: habit),

            const SizedBox(height: 24),

            // Toggle Completion Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  habitService.toggleHabitCompletion(habit.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: habit.isCompletedToday()
                      ? AppTheme.errorColor
                      : AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  habit.isCompletedToday() ? 'Undo Completion' : 'Mark as Complete',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Habit Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Habit Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      label: 'Frequency',
                      value: '${habit.frequencyDays} day${habit.frequencyDays > 1 ? 's' : ''} per week',
                    ),
                    _DetailRow(
                      label: 'Reminder',
                      value: habit.reminderTime.format(context),
                    ),
                    _DetailRow(
                      label: 'Created',
                      value: DateFormat('MMM d, yyyy').format(habit.createdAt),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, HabitService service, Habit habit) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: Text('Are you sure you want to delete "${habit.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              service.deleteHabit(habit.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletionCalendar extends StatelessWidget {
  final Habit habit;

  const _CompletionCalendar({required this.habit});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(28, (i) => now.subtract(Duration(days: 27 - i)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekday headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                  .map((d) => SizedBox(
                        width: 32,
                        child: Text(
                          d,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            // Calendar grid
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: days.map((day) {
                final isCompleted = habit.isCompletedOn(day);
                final isToday = day.year == now.year &&
                    day.month == now.month &&
                    day.day == now.day;

                return Container(
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.secondaryColor
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: isToday
                        ? Border.all(color: AppTheme.primaryColor, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isCompleted ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
