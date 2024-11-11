

import 'package:warehouse_master_mobile/entities/user.dart';

import '../repositories/user_repository.dart';

class GetUser {
  final UserRepository repository;

  GetUser({required this.repository});

  Future<User> call(int id) async {
    return await repository.getUser(id);
  }
}