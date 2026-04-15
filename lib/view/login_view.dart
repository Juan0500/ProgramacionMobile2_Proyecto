import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                'Bienvenido',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40),
              ),
              Text(
                'Inicia sesión para continuar',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 50),
              
              // Campo de Correo
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20),
              
              // Campo de Contraseña
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 40),

              // Boton con lógica de carga
              Consumer<LoginViewModel>(
                builder: (context, viewModel, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading 
                        ? null 
                        : () async {
                            bool success = await viewModel.login(
                              _emailController.text, 
                              _passwordController.text
                            );

                            if (success) {
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(viewModel.errorMessage)),
                              );
                            }
                          },
                      child: viewModel.isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Ingresar'),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text('¿No tienes cuenta? Regístrate'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}