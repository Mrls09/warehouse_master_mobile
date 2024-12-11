import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar para SharedPreferences
import 'package:warehouse_master_mobile/kernel/shared/custom_dialog_alert.dart';
import 'package:warehouse_master_mobile/kernel/utils/dio_client.dart';
import 'package:warehouse_master_mobile/kernel/widgets/form/text_form_field_email.dart';
import 'package:warehouse_master_mobile/kernel/widgets/form/text_form_field_password.dart';
import 'package:warehouse_master_mobile/modules/auth/auth_service.dart';
import 'package:warehouse_master_mobile/styles/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Clave del formulario
  late AuthService _authService;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final dioClient =
        DioClient(baseUrl: 'https://az3dtour.online:8443/warehouse-master-api/');
    _authService = AuthService(dio: dioClient.dio);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'auth_token', token); // Guardamos el token en SharedPreferences
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _username.text.trim();
      final password = _password.text.trim();
      setState(() {
        _isLoading = true;
      });
   
      final success = await _authService.login(email, password);

      if (success) {
        final token = await _authService.getToken();
        final uid = await _authService.getUid();
        print('UID guardado: $uid');
        if (token != null) {
          await _saveToken(token);
        }
        Navigator.pushNamed(context, '/nav');
      } else {
        setState(() {
          _isLoading = false; // Desactivar el loader
        });
        CustomDialogAlert(context).show(
          title: 'Error al inicar sesion',
          icon: const Icon(Icons.error, color: Colors.red),
          content:
              const Text('Credenciales invalidas porfavor intente de nuevo'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar',),
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  resizeToAvoidBottomInset: true,
  body: Stack(
    children: [
      Positioned.fill(
        child: SvgPicture.asset(
          'assets/backrund.svg',
          fit: BoxFit.cover,
        ),
      ),
      Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  color: AppColors.lightGray,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo.png',
                            width: 150, height: 150),
                        const Text(
                          '¡Bienvenido a WAREHOUSE!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deepRedAccent,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Ingrese su correo y contraseña para comenzar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.softPinkBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFieldEmail(
                          controller: _username,
                        ),
                        const SizedBox(height: 20),
                        TextFieldPassword(
                          controller: _password,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              '¿Has olvidado tu contraseña?',
                              style: TextStyle(
                                color: AppColors.deepMaroon,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                print('Recuperar contraseña');
                              },
                              child: const Text(
                                'Recuperar!',
                                style: TextStyle(
                                  color: AppColors.rosePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : _handleLogin, // Desactivar botón mientras carga
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.palePinkBackground,
                              backgroundColor: AppColors.rosePrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  )
                                : const Text('Iniciar Sesión'),
                          ),
                        ),
                        const SizedBox(height: 50), // Reducido para evitar overflow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              '¿Aun no cuentas con una cuenta?',
                              style: TextStyle(
                                color: AppColors.deepMaroon,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                print('Crear');
                              },
                              child: const Text(
                                'Crear!',
                                style: TextStyle(
                                  color: AppColors.rosePrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);

  }
}
