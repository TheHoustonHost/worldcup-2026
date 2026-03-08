import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final int frequencyDays; // 1-7, days per week
  final TimeOfDay reminderTime;
  final DateTime createdAt;
  int currentStreak;
  int bestStreak;
  final List<DateTime> completions;
  bool isPremium;

  Habit({
    required this.id,
    required this.name,
    required this.frequencyDays,
    required this.reminderTime,
    required this.createdAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
    List<DateTime>? completions,
    this.isPremium = false,
  }) : completions = completions ?? [];

  bool isCompletedToday() {
    final now = DateTime.now();
    return completions.any((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }

  bool isCompletedOn(DateTime date) {
    return completions.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  void toggleCompletion() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (isCompletedToday()) {
      // Remove today's completion
      completions.removeWhere((date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day);
      // Update streak
      if (currentStreak > 0) currentStreak--;
    } else {
      // Add today's completion
      completions.add(now);
      currentStreak++;
      if (currentStreak > bestStreak) {
        bestStreak = currentStreak;
      }
    }
  }

  double getCompletionRate() {
    if (completions.isEmpty) return 0.0;
    final daysSinceCreation = DateTime.now().difference(createdAt).inDays + 1;
    final expectedCompletions = (daysSinceCreation * frequencyDays / 7).round();
    if (expectedCompletions == 0) return 0.0;
    return (completions.length / expectedCompletions).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'frequencyDays': frequencyDays,
      'reminderTime': {
        'hour': reminderTime.hour,
        'minute': reminderTime.minute,
      },
      'createdAt': createdAt.toIso8601String(),
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'completions': completions.map((d) => d.toIso8601String()).toList(),
      'isPremium': isPremium,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      frequencyDays: json['frequencyDays'],
      reminderTime: TimeOfDay(
        hour: json['reminderTime']['hour'],
        minute: json['reminderTime']['minute'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      currentStreak: json['currentStreak'] ?? 0,
      bestStreak: json['bestStreak'] ?? 0,
      completions: (json['completions'] as List<dynamic>?)
              ?.map((d) => DateTime.parse(d))
              .toList() ??
          [],
      isPremium: json['isPremium'] ?? false,
    );
  }

  Habit copyWith({
    String? id,
    String? name,
    int? frequencyDays,
    TimeOfDay? reminderTime,
    DateTime? createdAt,
    int? currentStreak,
    int? bestStreak,
    List<DateTime>? completions,
    bool? isPremium,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      completions: completions ?? List.from(this.completions),
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
