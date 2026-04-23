import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/home_viewmodel.dart';
import '../model/habit_model.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        drawer: const Drawer(),
        appBar: AppBar(
          backgroundColor: AppTheme.background.withOpacity(0.8),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const Icon(Icons.explore, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(
                'Rastreando Hábitos',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      color: AppTheme.primary,
                    ),
              ),
            ],
          ),
          actions: [
            Consumer<HomeViewModel>(
              builder: (context, viewModel, child) {
                return GestureDetector(
                  onTap: () {
                    if (!viewModel.isPro) {
                      Navigator.pushNamed(context, '/payment').then((_) => viewModel.loadHabits());
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: viewModel.isPro ? AppTheme.primary : AppTheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      viewModel.isPro ? 'PRO' : 'BÁSICO',
                      style: TextStyle(
                        color: viewModel.isPro ? Colors.white : AppTheme.onSurfaceVariant,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
            const Icon(Icons.notifications_none, color: AppTheme.outline),
            const SizedBox(width: 16),
          ],
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
            }
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildHeader(context, viewModel),
                const SizedBox(height: 32),
                _buildBentoGrid(context, viewModel),
                const SizedBox(height: 32),
                _buildHabitsSection(context, viewModel),
              ],
            );
          },
        ),
        floatingActionButton: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/add_task').then((_) => viewModel.loadHabits()),
              backgroundColor: AppTheme.primary,
              child: const Icon(Icons.add, color: Colors.white),
              shape: const CircleBorder(),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HOY, ${DateTime.now().day} DE ${['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO', 'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'][DateTime.now().month - 1]}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              viewModel.userName.isNotEmpty ? 'Hola, ${viewModel.userName.split(" ").first}' : 'Hola!',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 72,
              height: 72,
              child: CircularProgressIndicator(
                value: viewModel.progress,
                strokeWidth: 8,
                backgroundColor: AppTheme.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
              ),
            ),
            Text(
              '${(viewModel.progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoGrid(BuildContext context, HomeViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
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
                const Icon(Icons.whatshot, color: AppTheme.primary, size: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('0', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                    Text('Días de racha', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (!viewModel.isPro) {
                Navigator.pushNamed(context, '/payment').then((_) => viewModel.loadHabits());
              }
            },
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: viewModel.isPro ? AppTheme.primary : AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: viewModel.isPro ? null : Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    viewModel.isPro ? Icons.workspace_premium : Icons.star_border, 
                    color: viewModel.isPro ? AppTheme.primaryContainer : AppTheme.outline, 
                    size: 32
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewModel.isPro ? 'Plan Pro' : 'Plan Básico',
                        style: TextStyle(
                          color: viewModel.isPro ? Colors.white : AppTheme.onSurface, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 18
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        viewModel.isPro ? 'Acceso ilimitado' : 'Mejorar plan',
                        style: TextStyle(
                          color: viewModel.isPro ? Colors.white70 : AppTheme.outline, 
                          fontSize: 11
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.habits.isEmpty) {
      return const Text('Aún no tienes hábitos registrados.', style: TextStyle(color: AppTheme.outline));
    }

    final upcoming = viewModel.upcomingHabits;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mis Hábitos', style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/all_habits');
              },
              child: const Text('Ver todos', style: TextStyle(color: AppTheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...viewModel.pendingToday.map((habit) => _buildHabitCard(context, habit, isUpcoming: false)),
        
        if (viewModel.completedToday.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Completados Hoy', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppTheme.outline)),
          const SizedBox(height: 12),
          ...viewModel.completedToday.map((habit) => _buildHabitCard(context, habit, isUpcoming: false)),
        ],
      ],
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
    return icons[iconName] ?? Icons.check_circle;
  }

  Widget _buildHabitCard(BuildContext context, HabitModel habit, {bool isUpcoming = false, bool isRoutine = false}) {
    final bool isCompleted = !isUpcoming && !isRoutine && habit.completedDates.contains(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final iconData = _getIconData(habit.icon);
    final isGeofence = habit.type == 'geocerca';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCompleted ? AppTheme.surfaceContainerHighest.withOpacity(0.5) : AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: isGeofence ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: isGeofence ? AppTheme.primary.withOpacity(0.05) : Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isGeofence ? AppTheme.primaryContainer : (isCompleted ? Colors.white : AppTheme.surfaceContainerLow),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: isGeofence ? AppTheme.primary : (isCompleted ? AppTheme.secondary : AppTheme.primary)),
          ),
          const SizedBox(width: 20),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted ? AppTheme.outline : AppTheme.onSurface,
                            ),
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
                        isRoutine 
                            ? 'Repite: ${habit.selectedDays.map((d) => ['L', 'M', 'Mi', 'J', 'V', 'S', 'D'][d]).join(', ')}'
                            : (isGeofence && habit.isAllDay ? 'Todo el día' : (isGeofence ? '${habit.startTime} - ${habit.endTime}' : habit.startTime)),
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
                       Text('Radio: ${habit.radius.toInt()}m', style: TextStyle(fontSize: 10, color: AppTheme.primary.withOpacity(0.8), fontWeight: FontWeight.bold)),
                       const SizedBox(width: 12),
                       const Icon(Icons.location_on, size: 12, color: AppTheme.outline),
                       const SizedBox(width: 4),
                       Text('${habit.latitude}, ${habit.longitude}', style: const TextStyle(fontSize: 10, color: AppTheme.outline)),
                     ],
                   ),
                   const SizedBox(height: 4),
                ] else ...[
                   Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12, color: AppTheme.outline),
                      const SizedBox(width: 4),
                      Text('Hábito común', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outline, fontSize: 10)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (!isUpcoming && !isRoutine)
            IconButton(
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.check_circle_outline, 
                color: AppTheme.primary
              ),
              onPressed: () {
                final viewModel = Provider.of<HomeViewModel>(context, listen: false);
                viewModel.toggleHabitCompletion(habit.id);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, Icons.home, 'Inicio', true),
          _buildNavItem(context, Icons.map_outlined, 'Mapa', false, route: '/map'),
          _buildNavItem(context, Icons.add_circle_outline, 'Nuevo', false, route: '/add_task'),
          _buildNavItem(context, Icons.person_outline, 'Perfil', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, bool isActive, {String? route}) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onTap: route != null 
              ? () => Navigator.pushNamed(context, route).then((_) {
                  if (route == '/add_task') {
                    viewModel.loadHabits();
                  }
                }) 
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? Colors.white : AppTheme.outline),
            if (isActive) ...[
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ],
          ],
        ),
      ),
    );
      },
    );
  }
}