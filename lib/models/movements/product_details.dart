import 'package:warehouse_master_mobile/models/movements/product.dart';
import 'package:warehouse_master_mobile/models/movements/rack.dart';

class ProductDetail {
  final Product product;
  final int quantity;
  final Rack destinationRack;

  ProductDetail({
    required this.product,
    required this.quantity,
    required this.destinationRack,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      destinationRack: Rack.fromJson(json['destinationRack']),
    );
  }
}
