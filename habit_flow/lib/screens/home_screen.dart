import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_service.dart';
import '../widgets/habit_card.dart';
import '../widgets/stat_card.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined),
            onPressed: () => Navigator.pushNamed(context, '/ai-coach'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Consumer<HabitService>(
        builder: (context, habitService, child) {
          final todaysHabits = habitService.getTodaysHabits();

          return CustomScrollView(
            slivers: [
              // Stats Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Completed',
                              value: '${habitService.completedToday}/${todaysHabits.length}',
                              icon: Icons.check_circle_outline,
                              color: AppTheme.secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              title: 'Active Streaks',
                              value: '${habitService.activeStreaks}',
                              icon: Icons.local_fire_department,
                              color: AppTheme.streakColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Best Streak',
                              value: '${habitService.bestOverallStreak} days',
                              icon: Icons.emoji_events,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              title: 'Success Rate',
                              value: '${(habitService.overallCompletionRate * 100).toStringAsFixed(0)}%',
                              icon: Icons.trending_up,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Habits Section Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Habits',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                      ),
                      if (!habitService.isPremium && habitService.totalHabits >= 3)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.streakColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Free limit: 3',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.streakColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Habits List
              if (todaysHabits.isEmpty)
                SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.add_task,
                            size: 64,
                            color: AppTheme.textSecondary.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No habits yet',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap + to create your first habit',
                            style: TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = todaysHabits[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: HabitCard(
                          habit: habit,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: habit.id,
                            );
                          },
                          onToggle: () {
                            habitService.toggleHabitCompletion(habit.id);
                          },
                        ),
                      );
                    },
                    childCount: todaysHabits.length,
                  ),
                ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
