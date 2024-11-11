import 'package:warehouse_master_mobile/entities/user.dart';
import 'package:warehouse_master_mobile/entities/warehouse.dart';
import 'package:warehouse_master_mobile/models/warehouse_model.dart';

class UserModel extends User {
  UserModel({
    required String uid,
    required String name,
    required String email,
    required String password,
    required String lastModified,
    required String role,
    required Warehouse warehouse,
    required bool active,
    required bool mfaEnabled,
  }) : super(
          uid,
          name,
          email,
          password,
          lastModified,
          role,
          warehouse,
          active,
          mfaEnabled,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      lastModified: json['lastModified'],
      role: json['role'],
      warehouse: WarehouseModel.fromJson(json['warehouse']),
      active: json['active'],
      mfaEnabled: json['mfaEnabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'lastModified': lastModified,
      'role': role,
      'warehouse': (warehouse as WarehouseModel).toJson(),
      'active': active,
      'mfaEnabled': mfaEnabled,
    };
  }
}
