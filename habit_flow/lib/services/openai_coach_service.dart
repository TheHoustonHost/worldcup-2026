import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/habit.dart';

class OpenAIAICoach {
  // Set your API key here or use environment variable
  static const String _defaultApiKey = '';
  static const String _defaultModel = 'gpt-4o-mini';
  
  final String _apiKey;
  final String _model;

  OpenAIAICoach({String? apiKey}) 
      : _apiKey = apiKey ?? _defaultApiKey,
        _model = _defaultModel;

  bool get isConfigured => _apiKey.isNotEmpty;

  Future<String> getChatResponse(String userMessage, List<Habit> habits) async {
    if (!isConfigured) {
      return "AI Coach is not configured. Add your OpenAI API key to enable personalized coaching!";
    }

    // Build context from user's habits
    String habitsContext = _buildHabitsContext(habits);

    final systemPrompt = '''You are HabitFlow's AI Coach, a friendly and motivating habit-building assistant. 
Your goal is to help users build positive habits through encouragement, practical tips, and accountability.

Current user's habits:
$habitsContext

Guidelines:
- Keep responses concise and actionable (under 100 words)
- Be encouraging but not preachy
- Provide specific, practical tips
- Reference their actual habits when giving advice
- Use emojis sparingly to keep it professional
- Never make up data about their habits - only use the data provided''';

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage}
          ],
          'max_tokens': 300,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "AI Coach is experiencing issues. Please try again later.";
      }
    } catch (e) {
      return "AI Coach is unavailable. Please check your connection.";
    }
  }

  Future<String> generateDailySummary(List<Habit> habits) async {
    if (!isConfigured) {
      return "AI Coach is not configured. Add your OpenAI API key to enable personalized coaching!";
    }

    String habitsContext = _buildHabitsContext(habits);

    final prompt = '''Generate a brief daily motivation message for a user with these habits:
$habitsContext

Today's date: ${DateTime.now().toString().split(' ')[0]}

Keep it under 50 words, encouraging, and reference their progress if applicable.''';

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': 'You are a motivational habit coach.'},
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 150,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['      } else {
        return "Keep building thosemessage']['content'];
 habits! Every step counts. 💪";
      }
    } catch (e) {
      return "Keep building those habits! Every step counts. 💪";
    }
  }

  Future<String> analyzeHabit(String habitName, Habit habit) async {
    if (!isConfigured) {
      return "AI Coach is not configured. Add your OpenAI API key for detailed analysis!";
    }

    final prompt = '''Analyze this habit and provide specific improvement suggestions:

Habit: $habitName
Current streak: ${habit.currentStreak} days
Best streak: ${habit.bestStreak} days
Total completions: ${habit.completions.length}
Completion rate: ${(habit.getCompletionRate() * 100).toStringAsFixed(0)}%
Frequency: ${habit.frequencyDays} days per week

Provide 2-3 specific, actionable tips to improve. Keep it under 80 words.''';

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': 'You are a habit-building expert.'},
            {'role': 'user', 'content': prompt}
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "Try linking this habit to your daily routine for better consistency!";
      }
    } catch (e) {
      return "Try linking this habit to your daily routine for better consistency!";
    }
  }

  String _buildHabitsContext(List<Habit> habits) {
    if (habits.isEmpty) {
      return "User has no habits yet.";
    }

    return habits.map((h) {
      return "- ${h.name}: ${h.currentStreak} day streak, ${(h.getCompletionRate() * 100).toStringAsFixed(0)}% completion rate";
    }).join('\n');
  }
}
