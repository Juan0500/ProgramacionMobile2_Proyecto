import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../theme.dart';
import '../viewmodel/add_task_viewmodel.dart';

class AddTaskView extends StatelessWidget {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddTaskViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.background.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Personalizar Hábito',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 18,
                  color: AppTheme.primary,
                ),
          ),
        ),
        body: Consumer<AddTaskViewModel>(
          builder: (context, viewModel, child) {
            bool isGeofence = viewModel.selectedType == TaskType.geocerca;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, 'TIPO DE HÁBITO'),
                  const SizedBox(height: 16),
                  _buildTypeSelector(context, viewModel),
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, 'DETALLES'),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Configura tu ',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                        ),
                        TextSpan(
                          text: isGeofence ? 'Geocerca' : 'Hábito',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 28,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (isGeofence) ...[
                    _buildMapPlaceholder(),
                    const SizedBox(height: 24),
                  ],
                  _buildTextField(
                    context,
                    label: 'NOMBRE DEL HÁBITO',
                    controller: viewModel.titleController,
                    hint: isGeofence ? 'Entrenamiento' : 'Meditar 10 min',
                  ),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'FRECUENCIA Y PERSONALIZACIÓN'),
                  const SizedBox(height: 16),
                  _buildDaySelector(context, viewModel),
                  const SizedBox(height: 24),
                  _buildSectionHeader(context, 'ELIGE UN ICONO'),
                  const SizedBox(height: 16),
                  _buildIconSelector(viewModel),
                  const SizedBox(height: 24),
                  if (isGeofence) ...[
                    _buildRadiusSelector(context, viewModel),
                    const SizedBox(height: 24),
                  ],
                  _buildTimeRangeSelector(context, viewModel, isGeofence),
                  if (isGeofence) ...[
                    const SizedBox(height: 24),
                    _buildTriggerLogic(context, viewModel),
                  ],
                  const SizedBox(height: 48),
                  _buildSaveButton(context, viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context, AddTaskViewModel viewModel) {
    return Row(
      children: [
        _buildTypeCard(
          context,
          'Común',
          Icons.schedule,
          viewModel.selectedType == TaskType.comun,
          () => viewModel.updateTaskType(TaskType.comun),
        ),
        const SizedBox(width: 16),
        _buildTypeCard(
          context,
          'Geocerca',
          Icons.location_on,
          viewModel.selectedType == TaskType.geocerca,
          () => viewModel.updateTaskType(TaskType.geocerca),
          isPro: true,
        ),
      ],
    );
  }

  Widget _buildTypeCard(BuildContext context, String label, IconData icon, bool isSelected, VoidCallback onTap, {bool isPro = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
                border: isSelected ? null : Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(icon, color: isSelected ? Colors.white : AppTheme.onSurfaceVariant, size: 32),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isPro)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white.withOpacity(0.2) : AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isSelected ? Colors.white : AppTheme.primary,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaySelector(BuildContext context, AddTaskViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('DÍA ESPECÍFICO (BÁSICO)', style: Theme.of(context).textTheme.labelSmall),
              Text(
                viewModel.specificDate != null ? DateFormat('d/M/yyyy').format(viewModel.specificDate!) : 'No seleccionado',
                style: TextStyle(fontSize: 12, color: viewModel.specificDate != null ? AppTheme.primary : AppTheme.outline),
              )
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => viewModel.pickSpecificDate(context),
              icon: const Icon(Icons.calendar_today, size: 16),
              label: const Text('Elegir Fecha en Calendario'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.surfaceContainerLow,
                foregroundColor: AppTheme.primary,
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('REPETICIÓN SEMANAL', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: viewModel.isPro ? AppTheme.onSurface : AppTheme.outline)),
              _buildProBadge(context, active: viewModel.isPro),
            ],
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: viewModel.isPro ? 1.0 : 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(viewModel.weekDays.length, (index) {
                bool isSelected = viewModel.selectedDays.contains(index);
                return GestureDetector(
                  onTap: () => viewModel.toggleDay(index),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerLow,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        viewModel.weekDays[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProBadge(BuildContext context, {bool active = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: active ? AppTheme.primaryContainer : AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'PRO',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: active ? AppTheme.primary : AppTheme.outline),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppTheme.secondary,
            letterSpacing: 2,
          ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA-csaIzLYGMiPuUe981-rrXNBFpPJw2FC-OZQkXzvc0KDMFs3aqVNTaJzAuTfB_PXYHIKIPJkR6yTvJ9eaf5LcOPEMdPeIKzt3UVtYXfQJUddajdL6-v2QJjComFNxraW8M8RvKLrIoEQCw8I_Zr3VS9cFdTJIe6GygK0wL2Xg6Ix55ocY_-9_V0fcLEPePvTiwCEflckGcpKty6MLYN3TaqRaNrx0mX_HaaqweXV4rBFht4RGnEpsoBVWyDjMuLltM4hSHEGQMPQ'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primary,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 16)],
          ),
          child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildIconSelector(AddTaskViewModel viewModel) {
    final icons = {
      'gym': Icons.fitness_center,
      'book': Icons.menu_book,
      'water': Icons.water_drop,
      'meditation': Icons.self_improvement,
      'fruit': Icons.apple,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: icons.entries.map((entry) {
        final isSelected = viewModel.selectedIcon == entry.key;
        return GestureDetector(
          onTap: () => viewModel.updateIcon(entry.key),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.primary : AppTheme.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              entry.value,
              color: isSelected ? Colors.white : AppTheme.outline,
              size: 20,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(BuildContext context,
      {required String label, required TextEditingController controller, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppTheme.outlineVariant),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              suffixIcon: const Icon(Icons.edit, color: AppTheme.primaryContainer, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadiusSelector(BuildContext context, AddTaskViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('RADIO DE GEOCERCA', style: Theme.of(context).textTheme.labelSmall),
              Text(
                '${viewModel.radius.toInt()}m',
                style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: viewModel.radius,
            min: 50,
            max: 1000,
            activeColor: AppTheme.primary,
            inactiveColor: AppTheme.surfaceContainerHigh,
            onChanged: viewModel.updateRadius,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector(BuildContext context, AddTaskViewModel viewModel, bool isGeofence) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isGeofence ? 'PERÍODO ACTIVO' : 'HORARIO', style: Theme.of(context).textTheme.labelSmall),
              if (isGeofence)
                Row(
                  children: [
                    const Text('Todo el día', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Switch(
                      value: viewModel.isAllDay,
                      onChanged: viewModel.toggleAllDay,
                      activeColor: AppTheme.primary,
                    ),
                  ],
                ),
            ],
          ),
          if (!viewModel.isAllDay) ...[
            const SizedBox(height: 16),
            if (isGeofence)
              Row(
                children: [
                  Expanded(child: _buildTimeBox('Inicio', viewModel.startTime.format(context), () => viewModel.pickStartTime(context))),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Icon(Icons.arrow_forward, color: AppTheme.outlineVariant, size: 16),
                  ),
                  Expanded(child: _buildTimeBox('Fin', viewModel.endTime.format(context), () => viewModel.pickEndTime(context))),
                ],
              )
            else
              _buildTimeBox('Hora de Notificación', viewModel.startTime.format(context), () => viewModel.pickStartTime(context)),
          ]
        ],
      ),
    );
  }

  Widget _buildTimeBox(String label, String value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 10, color: AppTheme.outlineVariant)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerLogic(BuildContext context, AddTaskViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DISPARAR AL', style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTriggerButton(
                  'Entrar',
                  Icons.login,
                  viewModel.notifyOnEntry,
                  () => viewModel.setNotifyOnEntry(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTriggerButton(
                  'Salir',
                  Icons.logout,
                  !viewModel.notifyOnEntry,
                  () => viewModel.setNotifyOnEntry(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerButton(String label, IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primary : AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? Colors.white : AppTheme.onSurfaceVariant, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, AddTaskViewModel viewModel) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppTheme.primary, Color(0xFF8B2511)]),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
        onPressed: viewModel.isLoading
            ? null
            : () async {
                bool success = await viewModel.saveTask();
                if (success) {
                  Navigator.pop(context);
                } else if (viewModel.errorMessage.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(viewModel.errorMessage)),
                  );
                }
              },
        child: viewModel.isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                'GUARDAR ${viewModel.selectedType == TaskType.geocerca ? 'GEOCERCA' : 'HÁBITO'}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5),
              ),
      ),
    );
  }
}
