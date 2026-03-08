import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

class HabitService extends ChangeNotifier {
  List<Habit> _habits = [];
  bool _isPremium = false;
  final _uuid = const Uuid();

  List<Habit> get habits => _habits;
  bool get isPremium => _isPremium;

  int get totalHabits => _habits.length;
  int get completedToday => _habits.where((h) => h.isCompletedToday()).length;
  int get activeStreaks => _habits.where((h) => h.currentStreak > 0).length;

  double get overallCompletionRate {
    if (_habits.isEmpty) return 0.0;
    return _habits.map((h) => h.getCompletionRate()).reduce((a, b) => a + b) /
        _habits.length;
  }

  int get bestOverallStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((h) => h.bestStreak).reduce((a, b) => a > b ? a : b);
  }

  HabitService() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      final List<dynamic> decoded = json.decode(habitsJson);
      _habits = decoded.map((h) => Habit.fromJson(h)).toList();
      _isPremium = prefs.getBool('isPremium') ?? false;
      notifyListeners();
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = json.encode(_habits.map((h) => h.toJson()).toList());
    await prefs.setString('habits', habitsJson);
    await prefs.setBool('isPremium', _isPremium);
  }

  Future<void> addHabit({
    required String name,
    required int frequencyDays,
    required TimeOfDay reminderTime,
  }) async {
    // Check free tier limit
    if (!_isPremium && _habits.length >= 3) {
      throw Exception('Free tier limit: 3 habits. Upgrade to premium for unlimited!');
    }

    final habit = Habit(
      id: _uuid.v4(),
      name: name,
      frequencyDays: frequencyDays,
      reminderTime: reminderTime,
      createdAt: DateTime.now(),
    );

    _habits.add(habit);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _saveHabits();
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].toggleCompletion();
      await _saveHabits();
      notifyListeners();
    }
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    final index = _habits.indexWhere((h) => h.id == updatedHabit.id);
    if (index != -1) {
      _habits[index] = updatedHabit;
      await _saveHabits();
      notifyListeners();
    }
  }

  Future<void> upgradeToPremium() async {
    _isPremium = true;
    await _saveHabits();
    notifyListeners();
  }

  Habit? getHabitById(String id) {
    try {
      return _habits.firstWhere((h) => h.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Habit> getTodaysHabits() {
    final now = DateTime.now();
    final weekday = now.weekday;
    return _habits.where((h) => weekday <= h.frequencyDays).toList();
  }
}
