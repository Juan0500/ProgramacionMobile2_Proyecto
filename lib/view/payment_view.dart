import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../viewmodel/payment_viewmodel.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: AppTheme.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.onSurface,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Plan Premium'),
          centerTitle: true,
        ),
        body: Consumer<PaymentViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.workspace_premium,
                    size: 80,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Desbloquea todo',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 32),

                  // Lista de beneficios desde el ViewModel
                  ...viewModel.benefits.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            benefit,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              final success = await viewModel.processPayment();
                              if (success && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Pagar \$4.99 / mes'),
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
}
