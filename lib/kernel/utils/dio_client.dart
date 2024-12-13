import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse_master_mobile/kernel/shared/snackbar_alert.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  DioClient({required String baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // Recupera el token del almacenamiento seguro
          //final token = await _secureStorage.read(key: 'authToken');
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token'; // Agregar token a las cabeceras
          }
        } catch (e) {
          print('Error reading token: $e');
        
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (response.statusCode == 200) {
          handler.next(response);
        } else {
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
            ),
          );
        }
      },
      onError: (error, handler) {
        if (error.response != null) {
          switch (error.response?.statusCode) {
            case 400:
              print("Bad Request");
              break;
            case 401:
              print("Unauthorized");
              break;
            case 500:
              print("Internal Server Error");
              break;
            default:
              print("Unhandled Error: ${error.response?.statusCode}");
          }
        }
        handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // Método para guardar el token
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: 'authToken', value: token);
  }

  // Método para borrar el token
  Future<void> clearToken() async {
    await _secureStorage.delete(key: 'authToken');
  }
}