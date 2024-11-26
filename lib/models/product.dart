class Product {
  final String uid;
  final String name;
  final String description;
  final double price;
  final int quantity;  // Cantidad de este producto en el movimiento
  final String qrCode;
  final String expirationDate;
  final bool active;
  final String lastModified;

  Product({
    required this.uid,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,  // Esta es la cantidad de productos
    required this.qrCode,
    required this.expirationDate,
    required this.active,
    required this.lastModified,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      uid: json['uid'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],  // Esto debe venir del JSON
      qrCode: json['qrCode'],
      expirationDate: json['expirationDate'],
      active: json['active'],
      lastModified: json['lastModified'],
    );
  }
}