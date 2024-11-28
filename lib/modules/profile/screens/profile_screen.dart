import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar para SharedPreferences
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Método para eliminar el token de SharedPreferences
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Eliminar el token guardado
    // Navegar a la pantalla de login o inicio
    Navigator.pushReplacementNamed(context, '/'); // Redirigir al login
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.softPinkBackground,
                        foregroundColor: Colors.white,
                        radius: 70,
                        child: Text('AH'),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Brayan Reynoso',
                            style: TextStyle(
                              fontSize: 28,
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('20213tn084@utez.edu.mx',
                             style: TextStyle(
                              fontSize: 16,
                              color: AppColors.lightGray,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _logout, // Llamar a la función de logout
                      style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.lightGray,
                          backgroundColor: AppColors.rosePrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*Icon(
                            Icons.logout, // Ícono de cerrar sesión
                            color: Colors.white,
                          ),*/
                          SizedBox(width: 8),
                          Text(
                            'Cerrar sesión',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
