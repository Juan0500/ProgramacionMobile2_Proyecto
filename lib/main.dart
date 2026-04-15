import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'view/login_view.dart';
import 'view/register_view.dart';
import 'view/home_view.dart';
import 'view/add_task_view.dart';
import 'view/map_view.dart';
import 'view/payment_view.dart';
import 'viewmodel/login_viewmodel.dart';
import 'viewmodel/register_viewmodel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
      ],
      child: const AppHabitos(),
    ),
  );
}

class AppHabitos extends StatelessWidget {
  const AppHabitos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rastreando Hábitos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/add_task': (context) => const AddTaskView(),
        '/map': (context) => const MapView(),
        '/payment': (context) => const PaymentView(),
      },
    );
  }
}