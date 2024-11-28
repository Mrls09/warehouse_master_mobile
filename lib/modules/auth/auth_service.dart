import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio dio;

  AuthService({required this.dio});

  static const String _loginEndpoint = '/auth/';

  Future<bool> login(String email, String password) async {
    try {
      // Realizar la solicitud POST
      final response = await dio.post(
        _loginEndpoint,
        data: {
          'email': email,
          'password': password,
        },
      );

      // Manejo de respuesta
      if (response.statusCode == 200) {
        final responseData = response.data;

        // Verificar si existe el token
        if (responseData != null && responseData['data'] != null) {
          final String token = responseData['data']['token'];
          print('Token recibido: $token');

          // Guardar token en SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          return true; // Inicio de sesión exitoso
        } else {
          print('Respuesta inesperada: ${response.data}');
          return false;
        }
      } else {
        print('Error en el inicio de sesión: Código ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en la solicitud de inicio de sesión: $e');
      return false;
    }
  }
  
  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); // Eliminar el token
    print('Sesión cerrada y token eliminado.');
  }

  // Obtener token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Obtener el token
  }

  // Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}