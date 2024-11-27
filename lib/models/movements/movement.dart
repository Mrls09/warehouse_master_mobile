import 'package:warehouse_master_mobile/models/movements/product_details.dart';
import 'package:warehouse_master_mobile/models/movements/user.dart';

class Movement {
  final String uid;
  final String status;
  final bool active;
  final String observations;
  final String lastModified;
  final User assignedUser;
  final List<ProductDetail> products;

  Movement({
    required this.uid,
    required this.status,
    required this.active,
    required this.observations,
    required this.lastModified,
    required this.assignedUser,
    required this.products,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      uid: json['uid'],
      status: json['status'],
      active: json['active'],
      observations: json['observations'],
      lastModified: json['lastModified'],
      assignedUser: User.fromJson(json['user']), // Asegúrate de que 'user' existe
      products: (json['products'] as List)
          .map((item) => ProductDetail.fromJson(item))
          .toList(),
    );
  }
}
