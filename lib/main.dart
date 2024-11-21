import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/modules/auth/login_screen.dart';
import 'package:warehouse_master_mobile/modules/entry/screens/entry_screen.dart';
import 'package:warehouse_master_mobile/modules/home/screens/home_screen.dart';
import 'package:warehouse_master_mobile/modules/output/screens/output_screen.dart';
import 'package:warehouse_master_mobile/modules/profile/screens/profile_screen.dart';
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
        '/login': (context) => const  LoginScreen(),
        '/app': (context) => const AppBarNavigation(),
        '/home': (context) => const HomeScreen(),
        '/output': (context) => const OutputScreen(),
        '/entry': (context) => const EntryScreen(),
        '/nav': (context) => const AppBarNavigation(),

      }
    );
  }
}
