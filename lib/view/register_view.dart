import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(backgroundColor: AppTheme.background, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Crear Cuenta', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 40),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre completo'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 40),
            Consumer<RegisterViewModel>(
              builder: (context, viewModel, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () async {
                      bool ok = await viewModel.register(
                        _nameController.text,
                        _emailController.text,
                        _passController.text
                      );
                      if (ok) {
                        Navigator.pop(context); // vuelve al login
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Cuenta creada, ya puedes entrar')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(viewModel.errorMessage)),
                        );
                      }
                    },
                    child: viewModel.isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Registrarme'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}