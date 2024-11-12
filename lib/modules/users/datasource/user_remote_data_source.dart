

import 'package:warehouse_master_mobile/entities/user.dart';
import 'package:warehouse_master_mobile/kernel/utils/dio_client.dart';

import '../../../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<User> getUser(int id);
  Future<User> createUser(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<User> getUser(int id) async {
    try {
      final response = await dioClient.dio.get('/users/$id');
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load user');
    }
  }

  @override
  Future<User> createUser(UserModel user) async {
    try {
      final response = await dioClient.dio.post('/users', data: user.toJson());
      return UserModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create user');
    }
  }
}
