import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/home_viewmodel.dart';

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
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const Icon(Icons.notifications_none, color: AppTheme.outline),
            const SizedBox(width: 16),
          ],
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _buildHeader(context, viewModel),
                const SizedBox(height: 32),
                _buildBentoGrid(context),
                const SizedBox(height: 32),
                _buildHabitsSection(context, viewModel),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/add_task'),
          backgroundColor: AppTheme.primary,
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
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
              'HOY, 1 DE ABRIL',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              'Hola, Juan',
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

  Widget _buildBentoGrid(BuildContext context) {
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
                    Text('12', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w900)),
                    Text('Días de racha', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 140,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.workspace_premium, color: AppTheme.primaryContainer, size: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Pro',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(
                      'Acceso ilimitado',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitsSection(BuildContext context, HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Mis Hábitos', style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () {},
              child: const Text('Ver todos', style: TextStyle(color: AppTheme.primary)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...viewModel.habits.map((habit) => _buildHabitCard(context, habit)),
      ],
    );
  }

  Widget _buildHabitCard(BuildContext context, Habit habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: habit.isCompleted ? AppTheme.surfaceContainerHighest.withOpacity(0.5) : AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
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
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: habit.isCompleted ? Colors.white : AppTheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(habit.icon, color: habit.isCompleted ? AppTheme.secondary : AppTheme.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      habit.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                            color: habit.isCompleted ? AppTheme.outline : AppTheme.onSurface,
                          ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        habit.time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.outline),
                    const SizedBox(width: 4),
                    Text(habit.location, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outline)),
                  ],
                ),
              ],
            ),
          ),
          if (!habit.isCompleted)
            IconButton(
              icon: const Icon(Icons.check_circle_outline, color: AppTheme.primary),
              onPressed: () {},
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
    return GestureDetector(
      onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
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
  }
}
