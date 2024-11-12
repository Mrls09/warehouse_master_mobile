import 'package:warehouse_master_mobile/entities/warehouse.dart';

class WarehouseModel extends Warehouse {
  WarehouseModel({
    required String uid,
    required String name,
    required String location,
    required int capacity,
    required bool active,
    required String lastModified,
  }) : super(
          uid,
          name,
          location,
          capacity,
          active,
          lastModified,
        );

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      uid: json['uid'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      active: json['active'],
      lastModified: json['lastModified'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'location': location,
      'capacity': capacity,
      'active': active,
      'lastModified': lastModified,
    };
  }
}