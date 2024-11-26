import 'package:warehouse_master_mobile/models/product.dart';
import 'package:warehouse_master_mobile/models/rack.dart';
import 'package:warehouse_master_mobile/models/warehouse.dart';

class MovementItem {
  final String uid;
  final List<Product> products;  // Ahora es una lista de productos
  final Warehouse sourceWarehouse;
  final Warehouse destinationWarehouse;
  final Rack sourceRack;  // Asegúrate de que se pase el rack de origen
  final String status;
  final String lastModified;
  final String photo;
  final String observations;

  MovementItem({
    required this.uid,
    required this.products,  // Ahora se pasa una lista de productos
    required this.sourceWarehouse,
    required this.destinationWarehouse,
    required this.sourceRack,  // Agregar este campo
    required this.status,
    required this.lastModified,
    required this.photo,
    required this.observations,
  });

  // Método para calcular la cantidad total de todos los productos en el movimiento
  int get totalQuantity {
    return products.fold(0, (sum, product) => sum + product.quantity);
  }
}