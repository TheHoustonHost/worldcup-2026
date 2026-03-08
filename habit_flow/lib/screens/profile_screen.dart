import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/habit_service.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Consumer<HabitService>(
        builder: (context, habitService, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: AppTheme.primaryColor,
                          child: const Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HabitFlow User',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${habitService.totalHabits} habits • ${habitService.activeStreaks} active streaks',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Premium Status
                Card(
                  color: habitService.isPremium
                      ? AppTheme.primaryColor.withOpacity(0.1)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: habitService.isPremium
                                ? AppTheme.primaryColor
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            habitService.isPremium
                                ? Icons.star
                                : Icons.star_border,
                            color: habitService.isPremium
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habitService.isPremium
                                    ? 'Premium Active'
                                    : 'Free Plan',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                habitService.isPremium
                                    ? 'Unlimited habits & AI Coach'
                                    : '${3 - habitService.totalHabits} habits remaining',
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!habitService.isPremium)
                          ElevatedButton(
                            onPressed: () => _showUpgradeDialog(context, habitService),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Upgrade'),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Summary
                const Text(
                  'All-Time Stats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _StatRow(
                  label: 'Total Habits Created',
                  value: '${habitService.totalHabits}',
                  icon: Icons.track_changes,
                ),
                _StatRow(
                  label: 'Best Streak Ever',
                  value: '${habitService.bestOverallStreak} days',
                  icon: Icons.emoji_events,
                ),
                _StatRow(
                  label: 'Overall Success Rate',
                  value: '${(habitService.overallCompletionRate * 100).toStringAsFixed(0)}%',
                  icon: Icons.trending_up,
                ),

                const SizedBox(height: 24),

                // Settings Section
                const Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.smart_toy,
                        title: 'AI Coach',
                        subtitle: 'Get personalized guidance',
                        onTap: () => Navigator.pushNamed(context, '/ai-coach'),
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Manage reminders',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.backup_outlined,
                        title: 'Backup Data',
                        subtitle: 'Export your habits',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'FAQ and contact',
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      _SettingsTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Version 1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sign Out
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Implement sign out
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.errorColor),
                      foregroundColor: AppTheme.errorColor,
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showUpgradeDialog(BuildContext context, HabitService service) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              size: 48,
              color: AppTheme.streakColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Upgrade to Premium',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Unlock unlimited habits and AI-powered coaching!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            _FeatureRow(icon: Icons.all_inclusive, text: 'Unlimited habits'),
            _FeatureRow(icon: Icons.smart_toy, text: 'AI Coach & suggestions'),
            _FeatureRow(icon: Icons.analytics, text: 'Advanced analytics'),
            _FeatureRow(icon: Icons.palette, text: 'Custom themes'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  service.upgradeToPremium();
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Welcome to Premium! 🎉'),
                      backgroundColor: AppTheme.secondaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Upgrade for \$4.99/mo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.secondaryColor, size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
