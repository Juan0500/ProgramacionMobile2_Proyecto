import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/habit_service.dart';
import '../services/auth_service.dart';
import '../model/habit_model.dart';

class HomeViewModel extends ChangeNotifier {
  final HabitService _habitService = HabitService();
  final AuthService _authService = AuthService();

  List<HabitModel> habits = [];
  bool isLoading = true;
  bool isPro = false;
  String userName = '';

  HomeViewModel() {
    loadHabits();
  }

  Future<void> loadHabits() async {
    isLoading = true;
    notifyListeners();

    final user = await _authService.getCurrentUser();
    if (user != null) {
      userName = user.name;
      isPro = user.isPro;
      habits = await _habitService.getUserHabits(user.id);
    } else {
      habits = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final success = await _habitService.toggleHabitCompletion(habitId, DateTime.now());
    if (success) {
      loadHabits(); 
    }
  }

  bool isForDate(HabitModel habit, DateTime date) {
    if (habit.specificDate != null && habit.specificDate!.isNotEmpty) {
      return habit.specificDate == DateFormat('yyyy-MM-dd').format(date);
    }
    int dayIndex = date.weekday - 1; 
    return habit.selectedDays.contains(dayIndex);
  }
  
  bool isCompletedToday(HabitModel habit) {
    return habit.completedDates.contains(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  List<HabitModel> get pendingToday {
    final now = DateTime.now();
    return habits.where((h) => isForDate(h, now) && !isCompletedToday(h)).toList();
  }

  List<HabitModel> get completedToday {
    final now = DateTime.now();
    return habits.where((h) => isForDate(h, now) && isCompletedToday(h)).toList();
  }

  List<HabitModel> get recurringHabits {
    return habits.where((h) => h.selectedDays.isNotEmpty).toList();
  }

  Map<DateTime, List<HabitModel>> get upcomingHabits {
    final Map<DateTime, List<HabitModel>> upcoming = {};
    final now = DateTime.now();

    for (int i = 1; i <= 30; i++) { // Revisaremos hasta 30 días para no perder hábitos agendados
      final targetDate = now.add(Duration(days: i));
      final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);
      
      final habitsForDay = habits.where((h) => h.selectedDays.isEmpty && isForDate(h, targetDate)).toList();
      if (habitsForDay.isNotEmpty) {
        upcoming[dateOnly] = habitsForDay;
      }
    }
    
    return upcoming;
  }

  double get progress {
    final todayHabits = habits.where((h) => isForDate(h, DateTime.now())).toList();
    if (todayHabits.isEmpty) return 0.0;
    
    int completed = todayHabits.where((h) => isCompletedToday(h)).length;
    return completed / todayHabits.length;
  }
}
