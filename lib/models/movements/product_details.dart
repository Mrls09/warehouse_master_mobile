import 'package:warehouse_master_mobile/models/movements/product.dart';
import 'package:warehouse_master_mobile/models/movements/rack.dart';
import 'package:warehouse_master_mobile/models/movements/warehouse.dart';

class ProductDetail {
  final Product product;
  final int quantity;
  final Rack? destinationRack;

  ProductDetail({
    required this.product,
    required this.quantity,
    required this.destinationRack,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    // Obtener el rack, si no está presente, crear un rack vacío
    Rack rackElement;
    if (json.containsKey('rack')) {
      rackElement = Rack.fromJson(json['rack']);
    } else {
      rackElement = Rack(
        uid: '',
        rackNumber: '',
        maxFloor: 0,
        active: false,
        lastModified: '',
        description: '',
        capacity: 0,
        warehouse: Warehouse.fromJson({
          'uid': '',
          'name': '',
          'description': '',
          'address': '',
          'active': false,
          'lastModified': ''
        }),
      );
    }

    // Obtener la cantidad desde el JSON (suponiendo que viene como 'quantity')
    final int quantity = json['quantity'] ?? 1;

    return ProductDetail(
      product: Product.fromJson(json['product']),
      quantity: quantity,
      destinationRack: rackElement,
    );
  }

  /// Método estático para procesar una lista de `ProductDetail` y calcular las cantidades totales.
  static List<ProductDetail> fromJsonList(List<dynamic> jsonList) {
    final Map<String, ProductDetail> productMap = {};

    for (final json in jsonList) {
      final ProductDetail detail = ProductDetail.fromJson(json);

      if (productMap.containsKey(detail.product.uid)) {
        // Sumar cantidad si ya existe el producto en el mapa
        final existingDetail = productMap[detail.product.uid]!;
        productMap[detail.product.uid] = ProductDetail(
          product: existingDetail.product,
          quantity: existingDetail.quantity + detail.quantity,
          destinationRack: existingDetail.destinationRack,
        );
      } else {
        // Agregar nuevo producto al mapa
        productMap[detail.product.uid] = detail;
      }
    }

    // Convertir el mapa a una lista de `ProductDetail`
    return productMap.values.toList();
  }
}
