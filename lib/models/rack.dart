import 'package:warehouse_master_mobile/models/warehouse.dart';

class Rack {
  final String uid;
  final Warehouse warehouse;
  final String rackNumber;
  final int capacity;
  final String description;
  final int maxFloor;
  final bool active;
  final String lastModified;

  Rack({
    required this.uid,
    required this.warehouse,
    required this.rackNumber,
    required this.capacity,
    required this.description,
    required this.maxFloor,
    required this.active,
    required this.lastModified,
  });

  factory Rack.fromJson(Map<String, dynamic> json) {
    return Rack(
      uid: json['uid'],
      warehouse: Warehouse.fromJson(json['warehouse']),
      rackNumber: json['rackNumber'],
      capacity: json['capacity'],
      description: json['description'],
      maxFloor: json['maxFloor'],
      active: json['active'],
      lastModified: json['lastModified'],
    );
  }
}
