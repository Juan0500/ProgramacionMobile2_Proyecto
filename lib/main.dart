import 'package:flutter/material.dart';
import 'theme.dart';
import 'view/login_view.dart';
import 'view/home_view.dart';
import 'view/add_task_view.dart';
import 'view/map_view.dart';

void main() {
  runApp(const AppHabitos());
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
        '/home': (context) => const HomeView(),
        '/add_task': (context) => const AddTaskView(),
        '/map': (context) => const MapView(),
      },
    );
  }
}
