import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/habit_model.dart';
import 'package:intl/intl.dart';

abstract class HabitRepository {
  Future<List<HabitModel>> getUserHabits(String userId);
  Future<bool> createHabit(HabitModel habit);
  Future<bool> updateHabit(HabitModel habit);
  Future<bool> deleteHabit(String habitId);
  Future<bool> toggleHabitCompletion(String habitId, DateTime date);
}

class LocalHabitRepository implements HabitRepository {
  Future<Map<String, dynamic>> _getHabitsDb() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = prefs.getString('app_database_habits_v2') ?? '{}';
    return jsonDecode(habitsString);
  }

  Future<void> _saveHabitsDb(Map<String, dynamic> db) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_database_habits_v2', jsonEncode(db));
  }

  @override
  Future<List<HabitModel>> getUserHabits(String userId) async {
    final db = await _getHabitsDb();
    final List<HabitModel> habits = [];

    for (var value in db.values) {
      final habit = HabitModel.fromJson(value);
      if (habit.userId == userId) {
        habits.add(habit);
      }
    }
    return habits;
  }

  @override
  Future<bool> createHabit(HabitModel habit) async {
    final db = await _getHabitsDb();
    db[habit.id] = habit.toJson();
    await _saveHabitsDb(db);
    return true;
  }

  @override
  Future<bool> updateHabit(HabitModel habit) async {
    final db = await _getHabitsDb();
    if (db.containsKey(habit.id)) {
      db[habit.id] = habit.toJson();
      await _saveHabitsDb(db);
      return true;
    }
    return false;
  }

  @override
  Future<bool> deleteHabit(String habitId) async {
    final db = await _getHabitsDb();
    if (db.containsKey(habitId)) {
      db.remove(habitId);
      await _saveHabitsDb(db);
      return true;
    }
    return false;
  }

  @override
  Future<bool> toggleHabitCompletion(String habitId, DateTime date) async {
    final db = await _getHabitsDb();
    if (db.containsKey(habitId)) {
      final habit = HabitModel.fromJson(db[habitId]);
      final dateString = DateFormat('yyyy-MM-dd').format(date);

      final List<String> dates = List.from(habit.completedDates);
      if (dates.contains(dateString)) {
        dates.remove(dateString);
      } else {
        dates.add(dateString);
      }

      final updatedHabit = HabitModel(
        id: habit.id,
        userId: habit.userId,
        title: habit.title,
        type: habit.type,
        icon: habit.icon,
        startTime: habit.startTime,
        endTime: habit.endTime,
        isAllDay: habit.isAllDay,
        notifyOnEntry: habit.notifyOnEntry,
        radius: habit.radius,
        latitude: habit.latitude,
        longitude: habit.longitude,
        locationName: habit.locationName,
        selectedDays: habit.selectedDays,
        specificDate: habit.specificDate,
        completedDates: dates,
      );

      db[habitId] = updatedHabit.toJson();
      await _saveHabitsDb(db);
      return true;
    }
    return false;
  }
}

class HabitService {
  final HabitRepository _repository = LocalHabitRepository();

  Future<List<HabitModel>> getUserHabits(String userId) => _repository.getUserHabits(userId);
  Future<bool> createHabit(HabitModel habit) => _repository.createHabit(habit);
  Future<bool> updateHabit(HabitModel habit) => _repository.updateHabit(habit);
  Future<bool> deleteHabit(String habitId) => _repository.deleteHabit(habitId);
  Future<bool> toggleHabitCompletion(String habitId, DateTime date) => _repository.toggleHabitCompletion(habitId, date);
}
