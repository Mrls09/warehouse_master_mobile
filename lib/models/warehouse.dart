class Warehouse {
  final String uid;
  final String name;
  final String location;
  final int capacity;
  final bool active;
  final String lastModified;

  Warehouse({
    required this.uid,
    required this.name,
    required this.location,
    required this.capacity,
    required this.active,
    required this.lastModified,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      uid: json['uid'],
      name: json['name'],
      location: json['location'],
      capacity: json['capacity'],
      active: json['active'],
      lastModified: json['lastModified'],
    );
  }
}