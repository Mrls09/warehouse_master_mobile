import 'package:warehouse_master_mobile/models/movements/category.dart';
import 'package:warehouse_master_mobile/models/movements/rack.dart';
import 'package:warehouse_master_mobile/models/movements/supplier.dart';

class Product {
  final String uid;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String expirationDate;
  final String? qrCode;
  final Supplier supplier;
  final Category category;
  final Rack rack;

  Product({
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.expirationDate,
    this.qrCode,
    required this.supplier,
    required this.category,
    required this.rack,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stock: json['stock'],
      expirationDate: json['expirationDate'],
      qrCode: json['qrCode'],
      supplier: Supplier.fromJson(json['supplier']),
      category: Category.fromJson(json['category']),
      rack: Rack.fromJson(json['rack']),
    );
  }
}
