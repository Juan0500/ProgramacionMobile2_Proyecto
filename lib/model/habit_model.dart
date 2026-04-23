class HabitModel {
  final String id;
  final String userId;
  final String title;
  final String type; 
  final String icon;
  
  // Opciones de Periodo
  final String startTime;
  final String endTime;
  final bool isAllDay; 
  
  // Opciones de Frecuencia
  final List<int> selectedDays; 
  final String? specificDate;

  // Opciones de Geocerca
  final bool notifyOnEntry;
  final double radius;
  final double latitude;
  final double longitude;
  final String locationName;
  
  // Historial
  final List<String> completedDates;

  HabitModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.icon,
    required this.startTime,
    required this.endTime,
    required this.isAllDay,
    required this.notifyOnEntry,
    required this.radius,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.selectedDays,
    this.specificDate,
    required this.completedDates,
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? 'comun',
      icon: json['icon'] ?? 'gym',
      startTime: json['startTime'] ?? '06:00',
      endTime: json['endTime'] ?? '22:00',
      isAllDay: json['isAllDay'] ?? false,
      notifyOnEntry: json['notifyOnEntry'] ?? false,
      radius: (json['radius'] ?? 0.0).toDouble(),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      locationName: json['locationName'] ?? '',
      selectedDays: List<int>.from(json['selectedDays'] ?? []),
      specificDate: json['specificDate'],
      completedDates: List<String>.from(json['completedDates'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'type': type,
      'icon': icon,
      'startTime': startTime,
      'endTime': endTime,
      'isAllDay': isAllDay,
      'notifyOnEntry': notifyOnEntry,
      'radius': radius,
      'latitude': latitude,
      'longitude': longitude,
      'locationName': locationName,
      'selectedDays': selectedDays,
      'specificDate': specificDate,
      'completedDates': completedDates,
    };
  }
}
