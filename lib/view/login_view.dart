import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.explore,
                    size: 48,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    viewModel.isLogin ? '¡Bienvenido de nuevo!' : 'Crea tu cuenta',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.isLogin ? 'Inicia sesión para continuar' : 'Únete a la comunidad de hábitos',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.outline),
                  ),
                  const SizedBox(height: 48),
                  if (!viewModel.isLogin) ...[
                    _buildTextField(
                      context,
                      label: 'NOMBRE COMPLETO',
                      controller: viewModel.nameController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildTextField(
                    context,
                    label: 'CORREO ELECTRÓNICO',
                    controller: viewModel.emailController,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context,
                    label: 'CONTRASEÑA',
                    controller: viewModel.passwordController,
                    icon: Icons.lock,
                    obscure: true,
                  ),
                  const SizedBox(height: 40),
                  _buildSubmitButton(context, viewModel),
                  const SizedBox(height: 24),
                  Center(
                    child: TextButton(
                      onPressed: viewModel.toggleMode,
                      child: Text(
                        viewModel.isLogin ? '¿No tienes cuenta? Regístrate' : '¿Ya tienes cuenta? Inicia sesión',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.primary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context,
      {required String label, required TextEditingController controller, required IconData icon, bool obscure = false}) {
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppTheme.outline, size: 20),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, LoginViewModel viewModel) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFFC0503D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          // Navegar a Home como ejemplo simple
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: Text(
          viewModel.isLogin ? 'INICIAR SESIÓN' : 'REGISTRARSE',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
