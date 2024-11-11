

import 'package:warehouse_master_mobile/entities/user.dart';

import '../repositories/user_repository.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser({required this.repository});

  Future<User> call(User user) async {
    return await repository.createUser(user);
  }
}