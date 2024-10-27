import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/modules/auth/code_validation_screen.dart';
import 'package:warehouse_master_mobile/modules/auth/email_validation_screen.dart';
import 'package:warehouse_master_mobile/modules/auth/login_screen.dart';
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
        '/verifyEmail': (context) => const EmailValidationScreen(),
        '/verifyCode': (context) => const CodeVerificationScreen(),
      }
    );
  }
}
