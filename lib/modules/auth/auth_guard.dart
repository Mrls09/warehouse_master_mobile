import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:warehouse_master_mobile/modules/auth/auth_service.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthentication(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data == true) {
          return child; // Si está autenticado, muestra la ruta protegida
        } else {
          // Si no está autenticado, redirige al login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const SizedBox();
        }
      },
    );
  }

  Future<bool> _checkAuthentication(BuildContext context) async {
    final authService = AuthService(dio: Dio());
    return await authService.isAuthenticated();
  }
}