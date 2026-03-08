import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit.dart';

class AICoachService {
  // For MVP, we'll use a simple rule-based system
  // In production, this would call OpenAI API
  
  final List<Map<String, String>> _motivationalMessages = [
    {"message": "Every expert was once a beginner. Keep going! 🚀", "type": "motivation"},
    {"message": "Small steps lead to big changes. You're on your way! 💪", "type": "motivation"},
    {"message": "Consistency is key. You've got this! 🔑", "type": "motivation"},
    {"message": "Today's effort is tomorrow's success. 🎯", "type": "motivation"},
    {"message": "Don't stop when you're tired, stop when you're done! ⚡", "type": "motivation"},
    {"message": "Your future self will thank you for doing this today. 🙏", "type": "motivation"},
    {"message": "Progress, not perfection. You're doing great! 🌟", "type": "motivation"},
    {"message": "One day at a time. One habit at a time. 💯", "type": "motivation"},
  ];

  final List<Map<String, String>> _streakMessages = [
    {"message": "Incredible streak! You're building real discipline! 🔥", "type": "streak"},
    {"message": "Your streak is on fire! Keep it burning! ✨", "type": "streak"},
    {"message": "Streaks create habits. You're almost there! 🎯", "type": "streak"},
    {"message": "This streak is impressive dedication! 👏", "type": "streak"},
  ];

  final List<Map<String, String>> _tipMessages = [
    {"message": "Try linking your habit to an existing routine for better consistency.", "type": "tip"},
    {"message": "Place a reminder in a visible spot to never forget!", "type": "tip"},
    {"message": "Start small - 2 minutes is better than nothing.", "type": "tip"},
    {"message": "Track your progress visually to stay motivated.", "type": "tip"},
    {"message": "Reward yourself after completing your habit this week!", "type": "tip"},
  ];

  String getDailyMotivation() {
    final now = DateTime.now();
    final index = (now.day + now.month) % _motivationalMessages.length;
    return _motivationalMessages[index]["message"]!;
  }

  String getStreakMotivation(int streakDays) {
    if (streakDays >= 7) {
      return "One week strong! You're unstoppable! 🏆";
    } else if (streakDays >= 3) {
      return _streakMessages[streakDays % _streakMessages.length]["message"]!;
    } else {
      return "Great start! Keep the momentum going! 💫";
    }
  }

  String getHabitTip(String habitName) {
    // Simple tips based on habit type
    final lowerHabit = habitName.toLowerCase();
    
    if (lowerHabit.contains('exercise') || lowerHabit.contains('workout') || lowerHabit.contains('gym')) {
      return "Try exercising at the same time each day to build a routine! 🏋️";
    } else if (lowerHabit.contains('read')) {
      return "Keep a book in places you wait - always have reading material! 📚";
    } else if (lowerHabit.contains('meditat') || lowerHabit.contains('mindful')) {
      return "Start with just 2 minutes - consistency beats duration! 🧘";
    } else if (lowerHabit.contains('water') || lowerHabit.contains('drink')) {
      return "Keep a water bottle at your desk as a visual reminder! 💧";
    } else if (lowerHabit.contains('sleep') || lowerHabit.contains('wake')) {
      return "Try the 10-3-2-1-0 rule: no caffeine 10hrs, no food 3hrs, no work 2hrs, no screens 1hr before bed! 😴";
    } else if (lowerHabit.contains('code') || lowerHabit.contains('program')) {
      return "Set a timer for 25 minutes - use the Pomodoro technique! 💻";
    } else if (lowerHabit.contains('write') || lowerHabit.contains('journal')) {
      return "Write just 3 sentences a day - small is sustainable! ✍️";
    }
    
    final index = DateTime.now().day % _tipMessages.length;
    return _tipMessages[index]["message"]!;
  }

  Map<String, dynamic> analyzeHabitPerformance(Habit habit) {
    final completionRate = habit.getCompletionRate();
    String status;
    String advice;
    String emoji;

    if (completionRate >= 0.8) {
      status = "Excellent";
      advice = "You're doing amazing! Consider adding a new challenge.";
      emoji = "🌟";
    } else if (completionRate >= 0.5) {
      status = "Good";
      advice = "You're making progress. Try linking this to an existing habit.";
      emoji = "👍";
    } else if (completionRate >= 0.25) {
      status = "Needs Work";
      advice = "Consider reducing frequency or changing the habit slightly.";
      emoji = "💪";
    } else {
      status = "Struggling";
      advice = "Maybe this habit is too ambitious. Start smaller!";
      emoji = "🤔";
    }

    return {
      "status": status,
      "advice": advice,
      "emoji": emoji,
      "completionRate": completionRate,
    };
  }

  List<String> generateHabitSuggestions() {
    return [
      "Morning stretch routine (5 minutes)",
      "Drink 8 glasses of water daily",
      "Read 10 pages before bed",
      "Practice deep breathing for 2 minutes",
      "Write 3 things you're grateful for",
      "No screens 1 hour before bed",
      "Take a 10-minute walk after lunch",
      "Meditate for 5 minutes each morning",
    ];
  }

  // Placeholder for OpenAI integration
  // In production, you would call the OpenAI API here
  Future<String> getPersonalizedAdvice(List<Habit> habits) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (habits.isEmpty) {
      return "Start by adding one habit you'd like to build. Even small steps lead to big changes!";
    }

    final habitsWithStreaks = habits.where((h) => h.currentStreak > 0).toList();
    final habitsWithoutStreaks = habits.where((h) => h.currentStreak == 0).toList();

    if (habitsWithStreaks.isEmpty) {
      return "Focus on completing one habit consistently for 3 days to build momentum!";
    }

    if (habitsWithoutStreaks.isNotEmpty) {
      final strugglingHabit = habitsWithoutStreaks.first;
      return "Try starting with '${strugglingHabit.name}' - it's easier to build one habit at a time.";
    }

    final bestHabit = habits.reduce((a, b) => a.currentStreak > b.currentStreak ? a : b);
    return "Great work on your '${bestHabit.name}' streak! You've built real discipline there. Consider using that momentum to start a new habit!";
  }
}
