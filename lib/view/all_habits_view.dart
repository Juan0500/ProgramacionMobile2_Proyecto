import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/home_viewmodel.dart';
import '../model/habit_model.dart';

class AllHabitsView extends StatelessWidget {
  const AllHabitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Mi Agenda Completa',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  color: AppTheme.primary,
                ),
          ),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                if (viewModel.recurringHabits.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Tus Rutinas Fijas', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18)),
                  ),
                  const SizedBox(height: 16),
                  _buildRoutinesCarousel(context, viewModel.recurringHabits),
                  const SizedBox(height: 32),
                ],
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text('Próximos Compromisos', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18)),
                ),
                const SizedBox(height: 16),
                if (viewModel.upcomingHabits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text('No hay eventos específicos agendados para los próximos 30 días.', style: TextStyle(color: AppTheme.outline)),
                  ),
                ...viewModel.upcomingHabits.entries.map((entry) {
                  const dias = ['LUNES', 'MARTES', 'MIÉRCOLES', 'JUEVES', 'VIERNES', 'SÁBADO', 'DOMINGO'];
                  String dayName = '${dias[entry.key.weekday - 1]} ${entry.key.day}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0, left: 4.0, top: 8.0),
                          child: Text(
                            dayName.toUpperCase(), 
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.outline, fontSize: 13, letterSpacing: 2)
                          ),
                        ),
                        ...entry.value.map((habit) => _buildUpcomingCard(context, habit)),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRoutinesCarousel(BuildContext context, List<HabitModel> routines) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final habit = routines[index];
          final isGeofence = habit.type == 'geocerca';
          final iconData = _getIconData(habit.icon);

          return Container(
            width: 160,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isGeofence ? AppTheme.primary.withOpacity(0.05) : AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              border: isGeofence ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1.5) : Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isGeofence ? AppTheme.primaryContainer : AppTheme.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: AppTheme.primary, size: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        habit.selectedDays.map((d) => ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'][d]).join(', '),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingCard(BuildContext context, HabitModel habit) {
    final iconData = _getIconData(habit.icon);
    final isGeofence = habit.type == 'geocerca';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: isGeofence ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isGeofence ? AppTheme.primaryContainer : AppTheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        habit.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isGeofence ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isGeofence && habit.isAllDay ? 'Todo el día' : (isGeofence ? '${habit.startTime} - ${habit.endTime}' : habit.startTime),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: isGeofence ? Colors.white : null,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                if (isGeofence) ...[
                   Row(
                     children: [
                       const Icon(Icons.radar, size: 12, color: AppTheme.primary),
                       const SizedBox(width: 4),
                       Text('${habit.radius.toInt()}m', style: TextStyle(fontSize: 10, color: AppTheme.primary.withOpacity(0.8), fontWeight: FontWeight.bold)),
                     ],
                   ),
                ] else ...[
                   Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: AppTheme.outline),
                      const SizedBox(width: 4),
                      Text('Específico', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outline, fontSize: 10)),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    const icons = {
      'gym': Icons.fitness_center,
      'book': Icons.menu_book,
      'water': Icons.water_drop,
      'meditation': Icons.self_improvement,
      'fruit': Icons.apple,
    };
    return icons[iconName] ?? Icons.event_note;
  }
}
