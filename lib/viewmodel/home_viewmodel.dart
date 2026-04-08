import 'package:flutter/material.dart';

class Habit {
  final String title;
  final String time;
  final String location;
  final IconData icon;
  final Color color;
  final bool isCompleted;

  Habit({
    required this.title,
    required this.time,
    required this.location,
    required this.icon,
    required this.color,
    this.isCompleted = false,
  });
}

class HomeViewModel extends ChangeNotifier {
  final List<Habit> habits = [
    Habit(
      title: 'Meditación Matinal',
      time: '07:00',
      location: 'Casa',
      icon: Icons.check_circle,
      color: const Color(0xFF6B5D2E),
      isCompleted: true,
    ),
    Habit(
      title: 'Running 5km',
      time: '18:30',
      location: 'Parque Rodó',
      icon: Icons.directions_run,
      color: const Color(0xFF9F402D),
    ),
    Habit(
      title: 'Lectura Nocturna',
      time: '22:00',
      location: 'Habitación',
      icon: Icons.book,
      color: const Color(0xFF77574E),
    ),
  ];

  double get progress => 0.7;
}
