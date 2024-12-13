import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:warehouse_master_mobile/kernel/utils/dio_client.dart';
import 'package:warehouse_master_mobile/modules/auth/auth_service.dart';
import 'package:warehouse_master_mobile/modules/auth/login_screen.dart';
import 'package:warehouse_master_mobile/navigation/app_bar_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  // Verificar si el usuario está autenticado
  Future<void> _checkAuthentication() async {
    try {
      final authService = AuthService(dio: DioClient(baseUrl: 'http://129.213.69.201:8081').dio);
      final isAuthenticated = await authService.isAuthenticated();

      // Usar Future.delayed para dar tiempo a la animación del splash
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        // Si está autenticado, redirige a la pantalla principal (Home)
        if (isAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AppBarNavigation()), // Reemplaza con tu pantalla principal
            (Route<dynamic> route) => false, // Elimina todas las pantallas anteriores
          );
        } else {
          // Si no está autenticado, redirige a la pantalla de login
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()), // Reemplaza con tu pantalla de login
            (Route<dynamic> route) => false, // Elimina todas las pantallas anteriores
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Si hay un error, redirigir al login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
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
            child: _isLoading
                ? const CircularProgressIndicator()  // Indicador de carga mientras verificamos la autenticación
                : Column(
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