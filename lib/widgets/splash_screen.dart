import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warehouse_master_mobile/modules/auth/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Verificar si el usuario está autenticado
  Future<void> _checkAuthentication() async {
    final authService = AuthService(dio: Dio());
    final isAuthenticated = await authService.isAuthenticated();

    Future.delayed(const Duration(seconds: 3), () {
      if (isAuthenticated) {
        // Si está autenticado, redirige al NavScreen
        Navigator.pushReplacementNamed(context, '/nav');
      } else {
        // Si no está autenticado, redirige al LoginScreen
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/backrund.svg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 200, height: 200),
                const SizedBox(height: 12),
                const Text(
                  'WareHouse',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
