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
    Rack rackElement;
    if(json.keys.contains('rack')){
      rackElement = Rack.fromJson(json['rack']);
    }else{
      rackElement = Rack(
        uid: '',
        rackNumber: '',
        maxFloor: 0,
        active: false,
        lastModified: '',
        description: '',
        capacity: 0,
        warehouse: Warehouse.fromJson(
          {
            'uid': '',
            'name': '',
            'description': '',
            'address': '',
            'active': false,
            'lastModified': ''
          }
        )
      );
    }

    return ProductDetail(
      product: Product.fromJson(json['product']),
      quantity: 1,
      destinationRack: rackElement,
    );
  }
}
