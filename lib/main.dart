import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/modules/auth/auth_guard.dart';
import 'package:warehouse_master_mobile/modules/auth/login_screen.dart';
import 'package:warehouse_master_mobile/modules/entry/screens/entry_screen.dart';
import 'package:warehouse_master_mobile/modules/movements/screens/movements_screen.dart';
import 'package:warehouse_master_mobile/modules/output/screens/output_screen.dart';
import 'package:warehouse_master_mobile/navigation/app_bar_navigation.dart';
import 'package:warehouse_master_mobile/widgets/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const AuthGuard(child: EntryScreen()),
          '/output': (context) => const AuthGuard(child: OutputScreen()),
          '/entry': (context) => const AuthGuard(child: MovementScreen()),
          '/nav': (context) => const AuthGuard(child: AppBarNavigation()) ,
        });
  }
}
