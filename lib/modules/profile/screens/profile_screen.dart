import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart'; // Agregar import para Dio
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = '';
  String _email = '';
  String _role = '';
  String _warehouse = '';
  String _location = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Método para obtener el token y UID de SharedPreferences y hacer la petición
  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('auth_uid'); // Obtener el UID

    if (uid != null) {
      try {
        final dio = Dio();
        final response = await dio.get(
          'https://az3dtour.online:8443/warehouse-master-api/users/get-user-uid/$uid',
        );

        if (response.statusCode == 200) {
          setState(() {
            _name = response.data['data']['name'];
            _email = response.data['data']['email'];
            _role = response.data['data']['role'];
            _warehouse = response.data['data']['warehouse']['name'];
            _location = response.data['data']['warehouse']['location'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error en la petición: $e');
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('UID no encontrado.');
    }
  }

  // Método para eliminar el token y uid de SharedPreferences
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Eliminar el token guardado
    await prefs.remove('auth_uid');   // Eliminar el uid guardado

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
                  // Avatar del usuario
                  CircleAvatar(
                    backgroundColor: AppColors.softPinkBackground,
                    foregroundColor: Colors.white,
                    radius: 80,
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : 'N/A',
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Información del usuario
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nombre
                        Row(
                          children: [
                            const Icon(Icons.person, color: AppColors.lightGray),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _name.isNotEmpty ? _name : 'Nombre no disponible',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: AppColors.lightGray,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        
                        // Correo
                        Row(
                          children: [
                            const Icon(Icons.email, color: AppColors.lightGray),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _email.isNotEmpty ? _email : 'Correo no disponible',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Rol
                        Row(
                          children: [
                            const Icon(Icons.work, color: AppColors.lightGray),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _role.isNotEmpty ? 'Rol: $_role' : 'Rol no disponible',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Almacén
                        Row(
                          children: [
                            const Icon(Icons.store, color: AppColors.lightGray),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _warehouse.isNotEmpty ? 'Almacén: $_warehouse' : 'Almacén no disponible',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Ubicación
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.lightGray),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _location.isNotEmpty ? 'Ubicación: $_location' : 'Ubicación no disponible',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  const Spacer(),
                  // Botón de cerrar sesión
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: _logout, // Llamar a la función de logout
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.rosePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Cerrar sesión',
                        style: TextStyle(color: Colors.white),
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
