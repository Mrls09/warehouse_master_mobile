import 'package:warehouse_master_mobile/models/movements/product_details.dart';
import 'package:warehouse_master_mobile/models/movements/user.dart';

class Movement {
  final String uid;
  final String status;
  final bool active;
  final String? observations;
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


const Map<String, String> statusDescriptions = {
  'UNASSIGNED_ENTRY': 'Entrada no asignada',
  'UNASSIGNED_EXIT': 'Salida no asignada',
  'UNASSIGNED_TRANSFER': 'Transferencia no asignada',
  'UNASSIGNED_ADJUSTMENT': 'Ajuste no asignado',
  'ASSIGNED_ENTRY': 'Entrada asignada',
  'ASSIGNED_EXIT': 'Salida asignada',
  'ASSIGNED_TRANSFER': 'Transferencia asignada',
  'ASSIGNED_ADJUSTMENT': 'Ajuste asignado',
  'PENDING_ENTRY': 'Entrada pendiente',
  'PENDING_EXIT': 'Salida pendiente',
  'PENDING_TRANSFER': 'Transferencia pendiente',
  'PENDING_ADJUSTMENT': 'Ajuste pendiente',
  'ENTRY': 'Entrada',
  'EXIT': 'Salida',
  'TRANSFER': 'Transferencia',
  'ADJUSTMENT': 'Ajuste',
  'CANCELLED': 'Cancelado',
};