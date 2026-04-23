import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/habit_service.dart';
import '../model/habit_model.dart';

enum TaskType { comun, geocerca }

class AddTaskViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final HabitService _habitService = HabitService();

  final TextEditingController titleController = TextEditingController();

  bool isPro = false;
  TaskType selectedType = TaskType.comun;

  double radius = 250.0;
  TimeOfDay startTime = const TimeOfDay(hour: 6, minute: 0);
  TimeOfDay endTime = const TimeOfDay(hour: 22, minute: 0);
  String selectedIcon = 'gym';
  bool notifyOnEntry = true;
  
  bool isAllDay = false;
  DateTime? specificDate;

  // Personalización de días (Lunes a Domingo)
  final List<String> weekDays = ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'];
  final Set<int> selectedDays = {};

  bool isLoading = false;
  String errorMessage = '';

  AddTaskViewModel() {
    _loadUserStatus();
  }

  Future<void> _loadUserStatus() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      isPro = user.isPro;
      notifyListeners();
    }
  }

  void updateTaskType(TaskType type) {
    if (type == TaskType.geocerca && !isPro) {
      errorMessage = 'Las tareas de Geocerca son exclusivas para usuarios Pro.';
      notifyListeners();
      return; 
    }
    
    selectedType = type;
    errorMessage = '';
    notifyListeners();
  }

  void toggleDay(int index) {
    if (!isPro) return; // Restringido a usuarios pro
    
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
    specificDate = null; // Limpiar fecha especificada si se elige recurrencia
    notifyListeners();
  }
  
  void toggleAllDay(bool value) {
    isAllDay = value;
    notifyListeners();
  }

  Future<void> pickSpecificDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: specificDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      specificDate = picked;
      selectedDays.clear(); // Limpiar recurrencia si eligen una fecha especifica
      notifyListeners();
    }
  }

  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: startTime,
    );
    if (picked != null) {
      startTime = picked;
      notifyListeners();
    }
  }
  
  Future<void> pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: endTime,
    );
    if (picked != null) {
      endTime = picked;
      notifyListeners();
    }
  }

  void updateRadius(double value) {
    radius = value;
    notifyListeners();
  }

  void updateIcon(String icon) {
    selectedIcon = icon;
    notifyListeners();
  }

  void setNotifyOnEntry(bool value) {
    notifyOnEntry = value;
    notifyListeners();
  }

  Future<bool> saveTask() async {
    if (titleController.text.isEmpty) {
      errorMessage = 'Debes ingresar un título.';
      notifyListeners();
      return false;
    }

    if (selectedDays.isEmpty && specificDate == null) {
      errorMessage = 'Selecciona una fecha o días de repetición.';
      notifyListeners();
      return false;
    }

    if (selectedType == TaskType.geocerca && !isPro) {
      errorMessage = 'No tienes permiso para crear tareas de Geocerca.';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    final user = await _authService.getCurrentUser();
    
    if (user == null) {
      errorMessage = 'Error de sesión.';
      isLoading = false;
      notifyListeners();
      return false;
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    
    String formattedSpecificDate = specificDate != null 
        ? DateFormat('yyyy-MM-dd').format(specificDate!) 
        : '';
        
    final newHabit = HabitModel(
      id: id,
      userId: user.id,
      title: titleController.text,
      type: selectedType == TaskType.comun ? 'comun' : 'geocerca',
      icon: selectedIcon,
      startTime: '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
      endTime: '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
      isAllDay: isAllDay,
      notifyOnEntry: notifyOnEntry,
      radius: radius,
      latitude: -34.9011, // Simulación
      longitude: -56.1645, // Simulación
      locationName: 'Locación elegida',
      selectedDays: selectedDays.toList(),
      specificDate: formattedSpecificDate.isNotEmpty ? formattedSpecificDate : null,
      completedDates: [],
    );

    final success = await _habitService.createHabit(newHabit);

    isLoading = false;
    
    if (!success) {
      errorMessage = 'Hubo un error al guardar.';
      notifyListeners();
      return false;
    }

    return true;
  }
}
