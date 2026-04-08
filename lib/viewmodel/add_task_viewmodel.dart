import 'package:flutter/material.dart';

enum TaskType { common, geofence }

class AddTaskViewModel extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();

  bool isPro = true;
  TaskType selectedType = TaskType.common;

  double radius = 250.0;
  TimeOfDay startTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 22, minute: 0);
  String selectedIcon = 'gym';
  bool notifyOnEntry = true;

  // Personalización de días (Lunes a Domingo)
  final List<String> weekDays = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
  final Set<int> selectedDays = {};

  void updateTaskType(TaskType type) {
    selectedType = type;
    notifyListeners();
  }

  void toggleDay(int index) {
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
    notifyListeners();
  }

  void updateRadius(double value) {
    radius = value;
    notifyListeners();
  }

  void updateIcon(String icon) {
    selectedIcon = icon;
    notifyListeners();
  }

  void updateStartTime(TimeOfDay time) {
    startTime = time;
    notifyListeners();
  }

  void updateEndTime(TimeOfDay time) {
    endTime = time;
    notifyListeners();
  }

  void setNotifyOnEntry(bool value) {
    notifyOnEntry = value;
    notifyListeners();
  }

  void saveTask() {
    //Acá se guardaria la tarea en la base de datos
  }
}
