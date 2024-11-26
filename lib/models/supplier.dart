class Supplier {
  final String uid;
  final String name;
  final String contact;
  final bool active;
  final String lastModified;

  Supplier({
    required this.uid,
    required this.name,
    required this.contact,
    required this.active,
    required this.lastModified,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      uid: json['uid'],
      name: json['name'],
      contact: json['contact'],
      active: json['active'],
      lastModified: json['lastModified'],
    );
  }
}
