

import 'package:warehouse_master_mobile/entities/user.dart';

import '../datasource/user_remote_data_source.dart';
import '../../../models/user_model.dart';

abstract class UserRepository {
  Future<User> getUser(int id);
  Future<User> createUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getUser(int id) async {
    return await remoteDataSource.getUser(id);
  }

  @override
  Future<User> createUser(User user) async {
    return await remoteDataSource.createUser(user as UserModel);
  }
}
